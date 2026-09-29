# Аудит багов iOS (2026-09-29)

Проверены: запуск и интро, deep links, карта (MapKit, `MapViewModel`), аудио (`AudioPlayer`, `AudioRepository`), сайдлоад через AltStore. Сборка и тесты не запускались: пользователь проверяет сам.

## Исправлено

### 1. AltStore: «The name " " contains invalid characters» (3009)
- **Где:** `OurMemory/App/Info.plist`, `CFBundleDisplayName` / `CFBundleName`.
- **Сценарий:** AltStore создаёт App ID с именем из нелокализованного `Info.plist`. В имени App ID допустимы только латиница, цифры и пробелы, поэтому «Наша память» превращается в `" "` и установка падает.
- **Исправление:** базовое имя стало `Our Memory`. Локализованные имена в `InfoPlist.xcstrings` не тронуты, так что на устройстве с русским языком под иконкой остаётся «Наша память».

### 2. Интро: кнопка «Начать» обрезается
- **Где:** `presentation/intro/ui/IntroScreen.swift`.
- **Сценарий:** кнопка стояла в `VStack` после `ScrollView` с `.ignoresSafeArea(edges: .top)`. На маленьком экране и с крупным шрифтом раскладка выталкивала её за нижний край.
- **Исправление:** кнопка перенесена в `.safeAreaInset(edge: .bottom)`, и место под неё над home indicator резервирует система.

### 3. Интро закрывает карточку ветерана при первом запуске по QR или ссылке
- **Где:** `presentation/root/RootView.swift`, `presentation/root/DeepLinkCenter.swift`.
- **Сценарий:** первый запуск по ссылке. `RootView` показывает основной экран, потому что `pendingVeteranId != nil`. `MainNavigationView` открывает карточку и обнуляет `pendingVeteranId`. Условие `!isIntroSeen && pendingVeteranId == nil` снова становится истинным, интро перекрывает экран, и карточка теряется.
- **Исправление:** `DeepLinkCenter.hasReceivedLink` не сбрасывается до конца процесса, и интро в этом запуске больше не показывается. При следующем обычном запуске интро покажется, так и задумано: пользователь его ещё не видел.

### 4. Метки захоронений мелкие и мыльные
- **Где:** `presentation/common/map/MapImages.swift`, `YandexMapCoordinator.applyMarkers`.
- **Сценарий:** PNG 20×25 px @1x.
- **Исправление:** метка рисуется в коде, 32×42 pt в разрешении экрана, с якорем на острие (`YMKIconStyle.anchor = (0.5, 1)`). Asset `icMarker.imageset` удалён.

### 5. Гонка при выборе метки на карте
- **Где:** `presentation/map/viewmodels/MapViewModel.refreshSelection`.
- **Сценарий:** пользователь нажимает метку и закрывает шторку (или нажимает другую метку) раньше, чем `resolveDirectUrl` загрузит фото. Устаревший результат снова открывает шторку или показывает не то захоронение.
- **Исправление:** после `await` результат применяется, только если `selectedBurialId` не изменился.

## Требует решения

### 6. Universal links не подключены
- **Где:** `OurMemory/App/OurMemory.entitlements`, сейчас пустой `<dict/>`.
- **Сценарий:** QR-код со ссылкой `https://chatroom-85fb8.web.app/veteran/{id}`, отсканированный системной камерой, открывает сайт, а не приложение. Внутренний QR-сканер и уведомления работают.
- **Почему не исправлено:** нужен `com.apple.developer.associated-domains` = `applinks:chatroom-85fb8.web.app` и платный аккаунт разработчика. Бесплатный Apple ID в AltStore эту способность не поддерживает, и с ней установка может не пройти.

### 7. Google Sign-In после переподписи AltStore
- **Сценарий:** AltStore с бесплатным аккаунтом дописывает к bundle id суффикс команды, например `com.gorman.ourmemory.XXXXXXXXXX`. OAuth-клиент iOS в `GoogleService-Info.plist` привязан к `com.gorman.ourmemory`, поэтому вход через Google в такой сборке, вероятно, не сработает. Firebase (база, анонимный вход, Storage) работать будет.
- **Что делать:** для полноценного входа нужна подпись с исходным bundle id (платный аккаунт или TestFlight).

### 8. Ошибка воспроизведения аудио не показывается
- **Где:** `data/audio/AudioPlayer.play`, ветка `status == .failed`.
- **Сценарий:** битый `audioUrl`. Плеер молча сбрасывается, и пользователь не понимает, почему звук не играет. Низкий приоритет.

## Сборка неподписанного .ipa

```bash
xcodegen generate && pod install
xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory -configuration Release \
  -sdk iphoneos -destination 'generic/platform=iOS' -archivePath build/OurMemory.xcarchive \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" archive
rm -rf build/ipa && mkdir -p build/ipa/Payload
cp -R build/OurMemory.xcarchive/Products/Applications/OurMemory.app build/ipa/Payload/
(cd build/ipa && zip -qry ../OurMemory.ipa Payload)
plutil -p build/ipa/Payload/OurMemory.app/Info.plist | grep -E "CFBundle(Display)?Name"
```
