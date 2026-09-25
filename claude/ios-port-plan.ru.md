# Перенос OurMemoryApp (Android) на iOS

## Контекст
Android-приложение `~/Personal/OurMemory-80` (~16.4k строк Kotlin, ~430 файлов: Compose, Hilt, Firebase RTDB/Auth/Storage, Yandex MapKit, Media3, WorkManager, TFLite) нужно перенести на iOS в пустую папку `~/Personal/OurMemory-ios` с **полным паритетом, включая админку**. Обе платформы работают с одной базой `chatroom-85fb8` → узел `OurMemory`, поэтому схема данных, пути, строковые значения статусов и правила должны совпадать байт в байт.

Решения (согласованы): SwiftUI, **iOS 17+**, `@Observable`; **Yandex MapKit**; **Core ML** из той же NSFW-модели; полный объём с админкой.

Первым действием после одобрения — сохранить этот план как `claude/ios-port-plan.ru.md` в iOS-репо (конвенция из Android `CLAUDE.md`), и создать iOS `CLAUDE.md` с перенесёнными конвенциями (один тип на файл, без комментариев, именованные константы, строки только через каталог локализации ru/be, ключи по содержимому, коммиты без упоминания Claude).

## Стек и структура проекта

| Android | iOS |
|---|---|
| Gradle | **XcodeGen** (`project.yml`, `brew install xcodegen`); `.xcodeproj` генерируется |
| Hilt | `AppContainer` (composition root) → передаётся через `@Environment` |
| Coroutines/Flow/StateFlow | async/await, `AsyncStream`, `@Observable` VM, `.task {}` вместо `stateIn` |
| Firebase BoM | SPM `firebase-ios-sdk` (Auth, Database, Storage, Analytics) |
| Credential Manager | SPM `GoogleSignIn-iOS` |
| Coil | SPM `Nuke`/`NukeUI` (`LazyImage`) |
| Yandex MapKit | CocoaPods `YandexMapsMobile` (4.x lite) → `OurMemory.xcworkspace` |
| Retrofit (Yandex Disk) | `URLSession` + `Codable` |
| Media3 + MediaSessionService | `AVPlayer`, `AVAudioSession(.playback, .spokenAudio)`, `MPNowPlayingInfoCenter`, background mode `audio` |
| WorkManager | `UNUserNotificationCenter` с календарными триггерами |
| DataStore | `UserDefaults` (те же ключи) |
| ML Kit QR | `VisionKit.DataScannerViewController` |
| TFLite | Core ML `NsfwClassifier.mlpackage` + Vision |
| strings.xml ru/be | `Localizable.xcstrings` (ru — исходный, be) с теми же ключами |

```text
OurMemory-ios/
├── project.yml  Podfile  Config/{Base,Secrets}.xcconfig  CLAUDE.md  claude/
├── tools/nsfw/convert_coreml.py
├── OurMemory/
│   ├── App/            OurMemoryApp.swift, AppDelegate.swift, AppContainer.swift, DeepLinkRouter.swift
│   ├── Domain/Models/  Veteran.swift, Burial.swift, Tour.swift, TourStop.swift, … (по одному типу)
│   ├── Domain/Repositories/  VeteransRepository.swift (protocol), …
│   ├── Data/Firebase/  DatabaseNodes.swift, VeteranKeys.swift, DatabaseReference+Observe.swift, DataSnapshot+Children.swift
│   ├── Data/<area>/{Repository,DataSource/Remote,DataSource/Local,Model,Mapper}/   (veterans, burials, tours, candles, favorites, account, auth, submissions, feedback, moderation, requests, content, media, contentcheck, settings)
│   ├── Playback/  AudioPlayer.swift, AudioRepository.swift
│   ├── Reminders/ ReminderScheduler.swift, VictoryDayReminderTime.swift, AnniversaryNotifications.swift
│   ├── UI/<feature>/{Views,ViewModels,Models}/  (intro, home, details, map, tours, info, more, favorites, myrequests, submission, feedback, navigation, admin/{login,home,veterans,burials,tours,moderation,feedbacklist,guide,common})
│   ├── UI/Common/{Views,Models}/  UI/Theme/
│   └── Resources/ Assets.xcassets (цвета light/dark, img1–10, splash, warwar, награды, news, ic_marker), Fonts/Mulish-*.ttf, Localizable.xcstrings, Media/veteran_bio_10.mp3, NsfwClassifier.mlpackage, GoogleService-Info.plist (git-ignored)
└── OurMemoryTests/  (порт всех unit-тестов + Fakes/)
```

## Этапы (каждый заканчивается зелёной сборкой `xcodebuild` и тестами)

### Этап 1. Каркас
**Почему:** без сгенерированного проекта, SPM/Pods и Firebase-конфига ничего не соберётся.
- `project.yml`: таргеты `OurMemory` (iOS 17, bundle `com.gorman.ourmemoryapp`, portrait), `OurMemoryTests`; Info.plist ключи: `NSLocationWhenInUseUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `UIBackgroundModes: [audio]`, `CFBundleLocalizations: [ru, be]`, URL scheme `REVERSED_CLIENT_ID`, entitlement `applinks:chatroom-85fb8.web.app`.
- `Config/Secrets.xcconfig` (git-ignored) с `MAPKIT_API_KEY` → Info.plist `MapKitApiKey`.
- `AppDelegate`: `FirebaseApp.configure()`, `Database.database().isPersistenceEnabled = true`, `YMKMapKit.setApiKey`, `UNUserNotificationCenter.delegate`.
- Копирование ресурсов из `app/src/main/res` (drawable → Assets, font → Fonts, raw → Media) скриптом; перенос 226 строк + 6 plurals + 6 string-array из `values/` и `values-be/` в `.xcstrings` скриптом (`claude/tools` в скретчпаде, не в репо). Плюралы → варианты `one/few/many/other`.

```swift
struct AppContainer {
    let veterans: VeteransRepository
    let burials: BurialsRepository
    let tours: ToursRepository
    let candles: CandlesRepository
    let favorites: FavoritesRepository
    let auth: AuthRepository
    let account: VisitorAccountRepository
    let submissions: SubmissionsRepository
    let feedback: FeedbackRepository
    let moderation: ModerationRepository
    let myRequests: MyRequestsRepository
    let contentEditor: ContentEditorRepository
    let media: MediaRepository
    let contentCheck: ContentCheckRepository
    let settings: SettingsRepository
    let tourProgress: TourProgressRepository
    let reminders: ReminderScheduler
    let audioPlayer: AudioPlayer
}
```

### Этап 2. Домен и данные (без UI)
**Почему:** это общий с Android контракт базы; ошибка в имени поля или статуса ломает данные для обеих платформ.
- Модели — `Codable` с дефолтами на каждое поле (аналог дефолтов Kotlin для `getValue`):

```swift
struct Veteran: Codable, Hashable, Identifiable {
    var id = ""
    var name = ""
    var portrait = ""
    var baseInfo = ""
    var allInfo = ""
    var years = ""
    var category = ""
    var rewards = ""
    var veteransInfo: [String] = []
    var burialId = ""
    var audioUrl = ""
    var birthDate = ""
    var deathDate = ""

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        veteransInfo = try container.decodeIfPresent([String].self, forKey: .veteransInfo) ?? []
    }
}
```
- `DataSnapshot.childrenAs<T>()` — декодирует каждого ребёнка через `data(as:)`, пропуская битых (как `DataSnapshotParsing.kt`). `DatabaseReference.observeValues()` → `AsyncThrowingStream`, снимающий observer в `onTermination` (аналог `DatabaseReferenceFlows.kt`).
- Репозитории 1:1 с `domain/repository/*`: кэш `actor` вместо `Mutex` + `invalidate()`; `Candles` — `runTransactionBlock` (+1, правило `newData == data+1`); `createdAt/reviewedAt` = `ServerValue.timestamp()`; `approve` — один `root.updateChildValues(ApprovalUpdates…)`; мои обращения — `queryOrdered(byChild: "authorUid").queryEqual(toValue: uid)`; `AnonymousSession.ensureSignedIn()` перед записью посетителя; Google — `link(with:)` анонимного, при `credentialAlreadyInUse` → `signIn(with: updatedCredential)`, затем `favorites addAll`.
- Чистая логика переносится дословно: `VeteranKeys.forId`, `resolveDirectUrl` (`cloud-api.yandex.net/v1/disk/public/resources/download?public_key=`), `parseRewards`/`toRewardsString`, `InfoBlocks`, `ApprovalUpdates`, `anniversaries(on:)`, `nextVictoryDayReminder`, `scaledSize` (2048, JPEG 0.85), `nextVeteranId`, `moved`, координаты `%.6f`, `VeteranLink.parseVeteranId`, `ProfanityDetector` (те же `LOOKALIKES`, `SAFE_FRAGMENTS`, `INFIX_ROOTS`, `EXACT_WORDS`, склейка однобуквенных слов).

```swift
enum ApprovalUpdates {
    static func updates(for approval: SubmissionApproval, currentInfo: [String], reviewer: String) -> [String: Any] {
        let text = approval.editedText.trimmingCharacters(in: .whitespacesAndNewlines)
        let newInfo = currentInfo + (text.isEmpty ? [] : [text]) + approval.approvedPhotoUrls.map { "\($0)|\(approval.photoCaption)" }
        let submissionPath = "\(DatabaseNodes.submissions)/\(approval.submission.id)"
        return [
            "\(DatabaseNodes.veterans)/\(VeteranKeys.forId(approval.submission.veteranId))/veteransInfo": newInfo,
            "\(submissionPath)/status": SubmissionStatusValues.approved,
            "\(submissionPath)/reviewedBy": reviewer,
            "\(submissionPath)/reviewedAt": ServerValue.timestamp(),
            "\(submissionPath)/reply": approval.reply.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
    }
}
```
- `UserDefaults`-ключи те же: `theme_mode`, `text_scale`, `victory_day_reminder`, `favorite_reminders`, `notifications_asked`, `favorite_veterans`, `candle_lit_{id}`, `requests_seen_at`, `tour_progress_{tourId}`; наблюдение через `AsyncStream` поверх `NotificationCenter` `UserDefaults.didChangeNotification`.
- NSFW: `tools/nsfw/convert_coreml.py` скачивает тот же `nsfw_mobilenet_v2_140_224` SavedModel и конвертирует `coremltools` (вход 224×224 RGB, scale 1/255, выход 5 классов). Пороги из `ContentCheckRepositoryImpl`: `porn ≥ 0.6 || hentai ≥ 0.6 || porn+hentai+sexy ≥ 0.8` → blocked, ошибка → unreadable. Если coremltools не возьмёт SavedModel — загрузить как Keras `tf.keras.models.load_model` и конвертировать его.

### Этап 3. Тема, навигация, общие компоненты
**Почему:** все экраны опираются на них.
- Цвета из `Color.kt` (light/dark) в Assets; `ThemeMode` → `.preferredColorScheme`; `TextScale` → `.dynamicTypeSize` (`.large`/`.xLarge`/`.xxLarge`) + `Font.custom("Mulish-…", size:, relativeTo:)`.
- Язык ru/be в приложении: `.environment(\.locale, …)` на корне + `LocalizedBundle` для строк вне `Text` (уведомления, VM). Выбор хранится в `app_language`.
- `RootView`: интро → `TabView` (Ветераны, Карта, О мемориале, Ещё, Админ — только при `session.isAdmin`) с собственным плавающим pill-баром; каждая вкладка — свой `NavigationStack(path:)` с `enum Route: Hashable { details(String), burialMap(String), tour(String), submission(String), feedback(String?), myRequests, favorites, adminLogin, adminGuide(GuideSection?), … }`.
- Deep link: `.onOpenURL` + `onContinueUserActivity` → `VeteranLink.parseVeteranId` → push `.details` во вкладке Ветераны; при старте по ссылке интро пропускается.
- Общие вью: `FloatingTopBar`, `HeroScrim`, `CircleIconButton`, `PillButton`, `CategoryFilterChips`, `ExpandableTextSection`, `MediaGallery` + `PhotoViewer` (zoom 1–5×), `SettingsGroup`/`SettingRow`/`LinkRow`, `LoadingView`/`ErrorView`, `QrScannerSheet`, `YandexMapView` (`UIViewRepresentable`), `MapPreview`, `NumberImage` (круг `#7F0410`, белая обводка).

### Этап 4. Экраны посетителя
Порт по одному фиче-пакету; VM повторяют `UiState`/`UiIntent` Android:
Intro → Home (поиск, фильтры War/Art, «В этот день») → Details (награды ×N, свеча, аудио, биография, медиа, захоронение, избранное, вклад) → Map (кластеризация radius 60 / minZoom 19, лист захоронения, слои MAP/HYBRID, моё местоположение, экскурсии) → Tour (маршрут-полилиния, прогресс, аудио остановок) → Info (статичный) → More (аккаунт Google, настройки, напоминания, вход админа) → Favorites → MyRequests (бейдж непросмотренных) → Submission (до 5 фото, NSFW-проверка, мат, согласие) → Feedback.

```swift
@Observable
final class HomeViewModel {
    private(set) var state: HomeUiState = .loading
    var search = "" { didSet { rebuild() } }
    var checkedWar = true { didSet { rebuild() } }
    var checkedArt = true { didSet { rebuild() } }
    private var veterans: [Veteran] = []
    private let repository: VeteransRepository

    init(repository: VeteransRepository) { self.repository = repository }

    func load() async {
        do { veterans = try await repository.getAllVeterans(); rebuild() }
        catch { state = .error }
    }
}
```

### Этап 5. Админка
Login → AdminHome (счётчики) → списки/редакторы ветеранов, захоронений (пикер точки на карте), экскурсий (выбор захоронения, порядок остановок, аудио) → Moderation list/review → Feedback list → Editor guide. Загрузки медиа: `PhotosPicker` (фото → сжатие 2048/0.85 → `Media/{folder}/{UUID}.jpg`), `.fileImporter([.audio])` → `Media/{folder}/{UUID}`. Исправить известный баг Android: аудио остановки привязывать к стабильному `UUID` формы остановки, а не к индексу.

### Этап 6. Аудио и напоминания
- `AudioPlayer` — один на приложение (аналог сервиса), `AudioRepository` на VM, `release()` останавливает только свой трек; позиция — `addPeriodicTimeObserver(0.5 s)`; Now Playing + remote commands.
- День Победы: `UNCalendarNotificationTrigger(month: 5, day: 9, hour: 10, repeats: true)`, id `victory_day_reminder`.
- Памятные даты избранных: вместо ежедневного воркера — предрасчитанные ежегодные триггеры по `birthDate`/`deathDate` (id `anniversary_{veteranId}_{kind}`), пересоздаются при изменении избранного, настройки и на старте; текст «День рождения · %d» / «День памяти · %d»; тап → deep link на карточку. Лимит iOS 64 ожидающих уведомления — ограничить ближайшими датами.

### Этап 7. Тесты и universal links
- Порт всех unit-тестов из `app/src/test` в XCTest с фейками из `testutil/` (VeteranFormats, BurialForm, ApprovalUpdates, ScaledSize, VeteranLink, RewardsParser, VeteranAnniversaries, VictoryDayReminderTime, TourProgress, репозитории, ViewModel-тесты).
- В Android-репо (отдельным коммитом, по согласованию): `firebase/public/.well-known/apple-app-site-association` с `appIDs: ["<TEAMID>.com.gorman.ourmemoryapp"]`, `components: [{"/": "/veteran/*"}]` + заголовок `application/json` в `firebase.json`.

## Что нужно от пользователя
1. В Firebase `chatroom-85fb8` добавить iOS-приложение `com.gorman.ourmemoryapp` и положить `GoogleService-Info.plist` в `OurMemory/Resources/` (в нём будет iOS OAuth client для Google Sign-In).
2. `MAPKIT_API_KEY` в `Config/Secrets.xcconfig`.
3. Apple Team ID для entitlements/AASA и подписи.
4. Разрешить `brew install xcodegen`.

## Проверка
```bash
xcodegen generate && pod install
xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory -destination 'platform=iOS Simulator,name=iPhone 17' build
xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory -destination 'platform=iOS Simulator,name=iPhone 17' test
```
Ручные сценарии в симуляторе (скриншоты через `xcrun simctl io booted screenshot`):
- Интро → список ветеранов грузится из Firebase, поиск и фильтры работают, «В этот день» при совпадении дат.
- Карточка: награды, свеча (+1 в базе, повторно в тот же день нельзя), аудио играет и в фоне, медиа из Яндекс.Диска открываются.
- `xcrun simctl openurl booted https://chatroom-85fb8.web.app/veteran/10` открывает карточку.
- Карта: маркеры, кластеры, лист захоронения, экскурсия с маршрутом и прогрессом.
- Отправка материалов и сообщения (появляются в `Submissions`/`Feedback`, видны в «Мои обращения»); мат и NSFW-фото блокируются.
- Вход админа, создание/редактирование ветерана, захоронения, экскурсии; одобрение заявки дописывает `veteransInfo` — изменения видны и в Android-приложении.
- Переключение ru/be, темы и размера текста; напоминания видны в `getPendingNotificationRequests`.

## Уточнение после утверждения: конвенции scryptowallet-ios
По просьбе пользователя `CLAUDE.md` построен на правилах `~/Projects/scryptowallet-ios/CLAUDE.md`, поэтому структура из раздела «Стек и структура проекта» заменяется на:

- слои `data/ → domain/ → presentation/`, `di/AppDIContainer.swift` с `buildXViewModel()`, токены `theme/` (`Palette`, `Typography`, `Spacing`, `CornerRadius`);
- ViewModel — `@Observable final class` с `xUiState` (`.loading` / `.success(data:)` / `.error`) и `onAction(XUserAction)`; живые данные — Combine-паблишеры, собираемые в `init`;
- экран = `XRoute` (владеет VM) + `XScreen` (чистый view с `#Preview`);
- один `MainRouter` и один `NavigationStack`, внутри — таб-бар; `navigationDestination` регистрируются один раз через `ViewModifier` каждой фичи;
- явный `return`, SF Symbols вместо векторных иконок Android, без Compose-словаря в именах (`CategoryFilter` вместо `CategoryFilterChips`, `CapsuleButton` вместо `PillButton`, `InfoEntry` вместо `InfoBlock`);
- `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, `SWIFT_APPROACHABLE_CONCURRENCY = YES`.

```swift
struct HomeRoute: View {
    @State private var viewModel: HomeViewModel

    var body: some View {
        switch viewModel.homeUiState {
        case .loading:
            return AnyView(LoadingView())
        case .success(let data):
            return AnyView(HomeScreen(data: data, onAction: viewModel.onAction))
        case .error:
            return AnyView(ErrorView())
        }
    }
}
```

## Уточнение: тесты
По решению пользователя новые тесты не пишутся. Уже готовые тесты data/domain (38 штук: ссылки, награды, даты, мат, ApprovalUpdates, кэши, свечи, авторизация, настройки) остаются; порт ViewModel-тестов из этапа 7 отменён.

## Уточнение: дизайн по Apple HIG (новый этап 6)
По требованию пользователя интерфейс не копирует Material-дизайн Android, а следует Apple Human Interface Guidelines на всех экранах:
- системный `TabView` с собственным `NavigationStack` в каждой вкладке (таб-бар не прячется при переходах, как в приложениях Apple), системные навигационные панели с крупными заголовками, свайп назад;
- `List`/`Form` в стиле insetGrouped для настроек, списков, форм и админки; `.searchable`, кнопки в тулбаре, `ContentUnavailableView` для пустых состояний, листы с detents;
- системный шрифт (SF, Dynamic Type) и семантические цвета iOS; от бренда остаётся только акцентный тёмно-красный.

```swift
TabView(selection: $router.selectedTab) {
    Tab("veterans", systemImage: "person.2", value: TopLevelTab.veterans) {
        NavigationStack(path: $router.veteransPath) {
            HomeRoute(viewModel: container.buildHomeViewModel(), onVeteranOpen: router.openVeteran)
                .modifier(AppNavigationDestinations(container: container, router: router))
        }
    }
}
```

## Уточнение: bundle id и конфиг Firebase
iOS-приложение в Firebase зарегистрировано как `com.gorman.ourmemory`, поэтому bundle id таргета — `com.gorman.ourmemory`, `GoogleService-Info.plist` хранится в репозитории, а URL-схема Google Sign-In подставляется из него скриптом после сборки. Для AASA: `<TEAMID>.com.gorman.ourmemory`.
