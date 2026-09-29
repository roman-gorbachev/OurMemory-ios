# iOS: имя приложения, IPA для AltStore, интро, метки карты, аудит багов

Репозиторий: `~/Personal/OurMemory-ios`. После одобрения план копируется в `claude/altstore-intro-markers-plan.ru.md` первым действием.

## Контекст

Список задач (переименовать приложение и собрать ipa, интро, метки Яндекса, поиск багов) нужно выполнить и в iOS-порте. Что уже известно:

- AltStore не ставит приложение: `AltStore.AppleDeveloperError 3009 — The name " " contains invalid characters` (`~/Documents/problem.tiff`). AltStore создаёт App ID, взяв имя из **нелокализованного** `Info.plist` (`CFBundleDisplayName` / `CFBundleName`). Там записано «Наша память», а имя App ID на портале Apple допускает только латиницу, цифры и пробелы. Кириллица вырезается, остаётся `" "`, отсюда ошибка. Поэтому здесь «переименовать» значит дать базовому имени ASCII-значение.
- Интро уже открывается только при первом запуске: флаг `intro_seen` хранится в `SettingsRepositoryImpl`, условие стоит в `RootView`. Остаётся проверить обрезку кнопки «Начать».
- Метка `icMarker.png` весит 20×25 px, @1x, и мелкая, и размытая. У Android тот же файл `drawable/ic_marker.png` (стоит упомянуть пользователю).
- `OurMemory.entitlements` пустой, то есть universal links (`applinks:`) не подключены. Это пойдёт в аудит.

## 1. Имя приложения: ASCII в базовом Info.plist

**Почему:** см. выше. Локализованные имена в `InfoPlist.xcstrings` (ru «Наша память», be, en, zh-Hans) остаются, поэтому на русском устройстве под иконкой по-прежнему будет «Наша память».

`OurMemory/App/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Our Memory</string>
<key>CFBundleName</key>
<string>Our Memory</string>
```

## 2. Неподписанный .ipa

**Почему:** AltStore сам переподписывает сборку своим Apple ID, а `DEVELOPMENT_TEAM` в `Secrets.xcconfig` пустой.

```bash
xcodegen generate && pod install
xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory -configuration Release \
  -sdk iphoneos -destination 'generic/platform=iOS' -archivePath build/OurMemory.xcarchive \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" archive
mkdir -p build/ipa/Payload && cp -R build/OurMemory.xcarchive/Products/Applications/OurMemory.app build/ipa/Payload/
(cd build/ipa && zip -qry ../OurMemory.ipa Payload)
```
Проверить, что `build/` есть в `.gitignore` (если нет, добавить). Результат: `build/OurMemory.ipa`. Проверка: `plutil -p Payload/OurMemory.app/Info.plist | grep CFBundleName` → `Our Memory`.

## 3. Интро: кнопка «Начать» обрезается

**Почему:** кнопка стоит после `ScrollView` в `VStack` внутри `GeometryReader`, а у `ScrollView` висит `.ignoresSafeArea(edges: .top)`. На маленьких экранах (iPhone SE) и с крупным Dynamic Type раскладка сжимается, и кнопка уезжает под нижний край. Сначала воспроизвожу в симуляторе (SE 3rd gen и крупный шрифт), потом переношу кнопку в системный `safeAreaInset`: он всегда резервирует ей место над home indicator и сдвигает под неё контент скролла.

`presentation/intro/ui/IntroScreen.swift`:
```swift
var body: some View {
    return GeometryReader { proxy in
        ScrollView {
            VStack(spacing: Spacing.xxl) {
                hero(height: proxy.size.height * Self.heroHeightRatio + proxy.safeAreaInsets.top)
                titleSection
                featuresSection
            }
            .padding(.bottom, Spacing.xxl)
        }
        .ignoresSafeArea(edges: .top)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            startButton
        }
    }
    .background(Palette.background.ignoresSafeArea())
}

private var startButton: some View {
    return Button(action: onStart) {
        Text("start")
            .appStyle(.headline)
            .frame(maxWidth: .infinity)
    }
    .buttonStyle(.borderedProminent)
    .controlSize(.large)
    .padding(.horizontal, Spacing.xxl)
    .padding(.vertical, Spacing.xl)
    .background(Palette.background)
}
```
Показ только при первом запуске уже работает (`RootViewModel.isIntroSeen` ← `introSeenPublisher()`), поэтому его я только проверяю вручную, без изменений в коде.

## 4. Метки захоронений: крупная векторная метка

**Почему:** PNG 20×25 @1x на Retina-экране выходит крошечным и мыльным. Рисую метку в коде в размере экрана и кэширую, так же как уже сделан `MapImages.number(_:)`. Asset `icMarker.imageset` удаляю, а в `CLAUDE.md` правлю строку про imagesets.

`presentation/common/map/MapImages.swift`:
```swift
private static let markerWidth: CGFloat = 32
private static let markerHeight: CGFloat = 42
private static let markerHoleRatio: CGFloat = 0.36
private static let markerStroke: CGFloat = 2
private static var markerCache: UIImage?

static var marker: UIImage {
    if let markerCache {
        return markerCache
    }
    let size = CGSize(width: markerWidth, height: markerHeight)
    let image = UIGraphicsImageRenderer(size: size).image { _ in
        let radius = markerWidth / 2 - markerStroke
        let center = CGPoint(x: markerWidth / 2, y: markerWidth / 2)
        let pin = UIBezierPath()
        pin.addArc(withCenter: center, radius: radius, startAngle: .pi * 0.8, endAngle: .pi * 0.2, clockwise: true)
        pin.addLine(to: CGPoint(x: markerWidth / 2, y: markerHeight - markerStroke))
        pin.close()
        brandRed.setFill()
        pin.fill()
        UIColor.white.setStroke()
        pin.lineWidth = markerStroke
        pin.stroke()
        let holeRadius = radius * markerHoleRatio
        UIColor.white.setFill()
        UIBezierPath(arcCenter: center, radius: holeRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true).fill()
    }
    markerCache = image
    return image
}
```
Чтобы острие метки указывало на точку, а не центр картинки, в `YandexMapCoordinator.applyMarkers` задаю якорь снизу:
```swift
private static let markerAnchor = CGPoint(x: 0.5, y: 1)

let style = YMKIconStyle()
style.anchor = NSValue(cgPoint: Self.markerAnchor)
placemark?.setIconWith(MapImages.marker, style: style)
```
Размер 32×42 pt подбираю на скриншоте симулятора. Кластеры (40 pt) остаются соразмерными.

## 5. Аудит багов и потенциальных проблем

**Почему:** это отдельный пункт списка. Прохожу по ключевым зонам: жизненный цикл карты и слушатели MapKit, аудио (`AudioPlayer`), deep links и интро, Combine-подписки и `[weak self]`, запись в Firebase (совпадение форматов с Android), обработка ошибок. Уже найдено: пустой `OurMemory.entitlements`, из-за чего universal links не работают. Находки с файлом и строкой, сценарием и серьёзностью записываю в `claude/bug-audit.ru.md`. Мелкие и очевидные исправляю сразу. Всё рискованное или требующее решения (например, entitlements и Associated Domains, которые бесплатный аккаунт AltStore не поддерживает) выношу пользователю, а не чиню молча.

## Коммиты (в main, без упоминаний ИИ)

1. `Give the app an ASCII bundle name for sideloading` (Info.plist)
2. `Keep the intro start button visible and enlarge map markers`
3. Исправления из аудита, отдельным коммитом, с `claude/bug-audit.ru.md`.

## Проверка

- `xcodegen generate && pod install`
- `xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory -destination 'platform=iOS Simulator,name=iPhone Duo' build` и `... test`
- Симулятор (skill `run`, скриншоты):
  - первый запуск → интро, кнопка «Начать» видна целиком на iPhone SE и с максимальным Dynamic Type; после «Начать» и перезапуска интро больше не показывается (`xcrun simctl terminate/launch`);
  - вкладка «Карта»: метки заметно крупнее, чёткие, остриём на точке; кластеры и номера туров не сломались;
  - на русской локали под иконкой «Наша память».
- Собрать `build/OurMemory.ipa`, проверить `CFBundleName` = `Our Memory`. Установку через AltStore делает пользователь на устройстве.
