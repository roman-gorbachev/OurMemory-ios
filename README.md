# OurMemory for iOS

An app about a historical military cemetery in Minsk: who is buried there, where each grave is and the stories behind the names. It is the SwiftUI version of the Android app [OurMemory-80](https://github.com/roman-gor/OurMemory-80). Both apps share one Firebase database, so the content, memorial candles and visitor submissions are the same in both.

The project started as a college assignment in mobile development and the digitization of historical data.

## Features

- **Veterans.** A list with search by name and a category filter. Each veteran's page has a biography, awards, photos, an audio biography, dates of birth and death, and the burial place.
- **Map.** Burials on Yandex MapKit with clustering, your location, and audio tours by stop.
- **Remembrance.** Light a candle (one counter shared by all visitors), add veterans to favorites (synced when signed in with Google), and get reminders for May 9 and anniversaries of favorite veterans.
- **QR codes.** The QR code on a grave plaque opens the veteran's page; universal links `https://chatroom-85fb8.web.app/veteran/{id}` work too.
- **Visitors.** Relatives can send memories and photos, and anyone can leave feedback or report a mistake. Admin replies show up under "My requests". Before sending, text is checked for profanity and photos for explicit content (Core ML).
- **Administration.** Editors for veterans, burials and tours with media uploads, moderation of submissions, and feedback review. A super admin adds administrators by e-mail.
- **Languages and appearance.** Russian, Belarusian, English and Chinese. Light and dark themes and adjustable text size. The UI follows Apple's Human Interface Guidelines.

## Tech stack

- Swift, SwiftUI, Observation, Combine, Swift Concurrency
- Firebase Auth, Realtime Database, Storage
- Google Sign-In
- Nuke for image loading
- Yandex MapKit (`YandexMapsMobile`, lite) via CocoaPods
- Core ML for photo checks
- XcodeGen for project generation

## Architecture

Three layers under `OurMemory/`, with dependencies pointing strictly one way: `presentation → domain → data`.

- `data/` holds data sources and repositories per area (veterans, burials, tours, candles, favorites, submissions and so on).
- `domain/` holds models, repository protocols and pure logic.
- `presentation/` holds screens per feature. Each has an `@Observable` view model with a single UI state; `XRoute` owns the view model and `XScreen` is a pure view.
- `di/AppDIContainer.swift` is the single composition root, with no DI framework.

Navigation uses the system `TabView`. Every tab has its own `NavigationStack`, and one shared `MainRouter` drives them all. The detailed conventions are in [CLAUDE.md](CLAUDE.md).

## Building

You need Xcode with the iOS 17+ SDK, [XcodeGen](https://github.com/yonaskolb/XcodeGen) and [CocoaPods](https://cocoapods.org).

1. Copy `Config/Secrets.example.xcconfig` to `Config/Secrets.xcconfig` and set:
   - `MAPKIT_API_KEY`: your Yandex MapKit key;
   - `DEVELOPMENT_TEAM`: your Apple Developer Team ID.
2. Generate the project and install the pods:
   ```bash
   xcodegen generate && pod install
   ```
3. Open `OurMemory.xcworkspace` (the workspace, not the `.xcodeproj`) or build from the terminal:
   ```bash
   xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory \
     -destination 'platform=iOS Simulator,name=iPhone 17' build
   ```

The `.xcodeproj` and `.xcworkspace` are generated and not tracked in git. Run step 2 again after adding files or changing `project.yml` or the `Podfile`.

Tests:

```bash
xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

## Tools

- `tools/strings/sync_android_strings.py` syncs the strings shared with the Android project into `Localizable.xcstrings`.
- `tools/nsfw/convert_coreml.py` rebuilds the `NsfwClassifier.mlpackage` model.
- `tools/icon/app_icon.svg` is the source of the app icon, shared by iOS and Android.

## Author

Roman Gorbachev
