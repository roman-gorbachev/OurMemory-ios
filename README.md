# OurMemory для iOS

Приложение об историческом военном кладбище в Минске: кто там похоронен, где находится каждое захоронение и какие истории стоят за именами. Это SwiftUI-версия Android-приложения [OurMemory-80](https://github.com/roman-gor/OurMemory-80). Оба приложения работают с одной базой Firebase, поэтому контент, свечи памяти и заявки у них общие.

Проект сделан как учебный в колледже, в рамках мобильной разработки и оцифровки исторических данных.

## Возможности

- **Ветераны.** Список с поиском по имени и фильтром по категориям. Карточка ветерана: биография, награды, фотографии, аудиобиография, дата рождения и смерти, место захоронения.
- **Карта.** Захоронения на Yandex MapKit с кластеризацией, ваше местоположение, аудиоэкскурсии по остановкам.
- **Память.** Можно зажечь свечу (общий счётчик для всех посетителей), добавить ветерана в избранное (с Google-аккаунтом избранное синхронизируется), получать напоминания о 9 Мая и памятных датах избранных ветеранов.
- **QR-коды.** QR на табличке открывает карточку ветерана; работают и универсальные ссылки `https://chatroom-85fb8.web.app/veteran/{id}`.
- **Посетители.** Родственники присылают воспоминания и фото, любой посетитель может отправить отзыв или сообщить об ошибке. Ответы администраторов появляются в «Моих обращениях». Перед отправкой текст проверяется на мат, а фото — на откровенный контент (Core ML).
- **Администрирование.** Редакторы ветеранов, захоронений и экскурсий с загрузкой медиа, модерация заявок, обратная связь. Супер-администратор назначает администраторов по e-mail.
- **Языки и оформление.** Русский, белорусский, английский и китайский. Светлая и тёмная тема, настраиваемый размер текста. Интерфейс сделан по Apple Human Interface Guidelines.

## Стек

- Swift, SwiftUI, Observation, Combine, Swift Concurrency
- Firebase Auth, Realtime Database, Storage
- Google Sign-In
- Nuke для загрузки изображений
- Yandex MapKit (`YandexMapsMobile`, lite) через CocoaPods
- Core ML для проверки фото
- XcodeGen для генерации проекта

## Архитектура

Три слоя в `OurMemory/`, зависимости идут строго в одну сторону `presentation → domain → data`:

- `data/` — источники данных и репозитории по областям (ветераны, захоронения, экскурсии, свечи, избранное, заявки и т. д.);
- `domain/` — модели, протоколы репозиториев и чистая логика;
- `presentation/` — экраны по фичам: `@Observable` ViewModel с одним UI-состоянием, `XRoute` владеет ViewModel, `XScreen` — чистое представление;
- `di/AppDIContainer.swift` — единственная точка сборки зависимостей, без DI-фреймворка.

Навигация: системный `TabView`, у каждой вкладки свой `NavigationStack`, всем управляет общий `MainRouter`. Подробные правила описаны в [CLAUDE.md](CLAUDE.md).

## Сборка

Нужны Xcode с iOS SDK 17+, [XcodeGen](https://github.com/yonaskolb/XcodeGen) и [CocoaPods](https://cocoapods.org).

1. Скопируйте `Config/Secrets.example.xcconfig` в `Config/Secrets.xcconfig` и укажите:
   - `MAPKIT_API_KEY` — ключ Yandex MapKit;
   - `DEVELOPMENT_TEAM` — ваш Team ID в Apple Developer.
2. Сгенерируйте проект и установите поды:
   ```bash
   xcodegen generate && pod install
   ```
3. Откройте `OurMemory.xcworkspace` (именно workspace, а не `.xcodeproj`) или соберите из терминала:
   ```bash
   xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory \
     -destination 'platform=iOS Simulator,name=iPhone 17' build
   ```

`.xcodeproj` и `.xcworkspace` генерируются и в git не хранятся. После добавления файлов или изменения `project.yml`/`Podfile` запустите шаг 2 заново.

Тесты:

```bash
xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

## Инструменты

- `tools/strings/sync_android_strings.py` синхронизирует общие строки из Android-проекта в `Localizable.xcstrings`.
- `tools/nsfw/convert_coreml.py` пересобирает модель `NsfwClassifier.mlpackage`.
- `tools/icon/app_icon.svg` — исходник иконки приложения, общий для iOS и Android.

## Автор

Роман Горбачёв
