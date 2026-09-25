# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

OurMemory — the SwiftUI iOS port of the Android app in `~/Personal/OurMemory-80` (its `CLAUDE.md` describes the product and the Firebase data model in detail). It digitizes a historical military cemetery in Minsk: a list of veterans, a detail page per veteran (bio, rewards, photos, audio biography, candle, favorites), a Yandex MapKit map with burials and audio tours, visitor submissions and feedback, and an admin area (content editors, moderation, feedback). Single app target `OurMemory`, bundle id `com.gorman.ourmemory`, iOS deployment target 17.0.

Both apps share one Firebase Realtime Database (`chatroom-85fb8`, everything under the `OurMemory` node), so node names, field names, status strings and write shapes must stay byte-for-byte identical to Android.

Fonts are the system SF family (no bundled fonts). Dependencies: Firebase (Auth, Database, Storage), GoogleSignIn and Nuke through SwiftPM; `YandexMapsMobile` (lite) through CocoaPods, because Yandex ships no SwiftPM package.

## Team Conventions

### Files
Save all Claude-generated documents (plans, review summaries, task lists) in the `claude/` folder at the repo root. Plans must be written in Russian and saved as `.md` files there (`claude/<topic>-plan.ru.md`).

### Commit Messages
Every commit message follows this structure:

```
Short summary of the feature(s) in general terms

- First feature in one sentence
- Second feature in one sentence
```

The first line is a general one-line description of what the commit does, followed by a blank line and a bullet list where each bullet describes one feature/change in a single sentence. Omit the bullet list only when the commit truly contains a single change already covered by the summary line. Commit after each finished block of work.

Never mention Claude, Anthropic, or any AI assistant in a commit message — no `Co-Authored-By: Claude`, no "Generated with Claude Code", no trailers or footers of any kind referencing them.

### Mindset
Do not be a yes-man. If a proposed approach has problems, say so and explain the trade-off before implementing. State your position first; implement what the user decides after the discussion.

### Swift Code Rules

**One type per file:** Every `class`, `struct`, `enum`, `protocol`, and `actor` lives in its own file named after the type. The only exceptions are small private helper types used exclusively by one other type in the same file.

**No comments:** Do not write any comments in Swift source files — no `//`, no `/* */`, no doc comments (`///`, `/** */`). Self-documenting names are the only acceptable form of documentation.

**Named constants:** All numeric limits (sizes, timeouts, thresholds, counts, zoom levels, etc.) must be a `private static let` (or a `private` constant in the owning type). Never write a raw number inline where the value carries meaning.

**Explicit `return`:** Always write `return` in non-`Void` functions and closures, even when Swift allows single-expression implicit returns. Applies to computed properties, single-statement function bodies, and trailing closures alike.

**Localization:** Never hardcode user-facing strings. Every string shown in the UI goes through `OurMemory/Resources/Localizable.xcstrings` (Russian source, Belarusian translation; add both) via `String(localized:)` / SwiftUI's automatic `Text` localization. Keys are the Android string resource names and mirror the content in English, snake_case (`search_by_name`, `veteran_not_found_msg`).

## Build & run

The `.xcodeproj` and `.xcworkspace` are generated (XcodeGen + CocoaPods) and git-ignored; always build the workspace.

```bash
xcodegen generate && pod install        # after cloning, adding/removing files, or changing project.yml / Podfile

xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory \
  -destination 'platform=iOS Simulator,name=iPhone Duo' build

xcodebuild -workspace OurMemory.xcworkspace -scheme OurMemory \
  -destination 'platform=iOS Simulator,name=iPhone Duo' test
```

Unit tests live in `OurMemoryTests/` (fakes in `OurMemoryTests/fakes/`); run one class with `-only-testing:OurMemoryTests/<ClassName>`.

The NSFW model is rebuilt with `uv run --python 3.11 --with-requirements tools/nsfw/requirements.txt tools/nsfw/convert_coreml.py`; the resulting `NsfwClassifier.mlpackage` is committed.

## Configuration & secrets

- `Config/Secrets.xcconfig` (git-ignored, template `Config/Secrets.example.xcconfig`) defines `MAPKIT_API_KEY` and `DEVELOPMENT_TEAM`. `Config/Base.xcconfig` includes it; the per-target `App.*.xcconfig` / `Tests.*.xcconfig` include the Pods config first. Values reach runtime through `OurMemory/App/Info.plist` (`$(KEY)`) and `enum AppConfig` via `Bundle.main.object(forInfoDictionaryKey:)`. Adding a value takes three edits: the xcconfig, `Info.plist`, and an `AppConfig` accessor.
- `OurMemory/Resources/GoogleService-Info.plist` is committed: it is the Firebase config of the iOS app `com.gorman.ourmemory` in `chatroom-85fb8`. The bundle id in `project.yml` must match it, or Google Sign-In fails.
- The Google Sign-In URL scheme is not written by hand: the post-build script "Register Google Sign-In URL scheme" in `project.yml` copies `REVERSED_CLIENT_ID` from the plist into the built `Info.plist`. `GoogleSignInLauncher` refuses to call the SDK when the scheme is missing, because GoogleSignIn throws an exception in that case.
- Universal links (`applinks:chatroom-85fb8.web.app`, path `/veteran/*`) need `apple-app-site-association` with `<TEAMID>.com.gorman.ourmemory`, served from the Android repo's `firebase/public/.well-known/`.

## Architecture

Three layers under `OurMemory/`, with a strict dependency direction `presentation → domain → data`:

- **`data/`** — per area (`veterans/`, `burials/`, `tours/`, `candles/`, `favorites/`, `account/`, `auth/`, `submissions/`, `feedback/`, `moderation/`, `requests/`, `content/`, `media/`, `contentcheck/`, `settings/`, `audio/`), each split into `datasource/`, `repository/`, `models/`, `mappers/` as needed. Each area follows `XDataSource` (protocol) / `XDataSourceImpl`, then `XRepositoryImpl` implementing the `domain` protocol. DTOs expose `toDomainModel()`. `data/firebase/` holds `DatabaseNodes`, `VeteranKeys`, snapshot decoding (`childrenAs`) and `observeValues()` publishers.
- **`domain/`** — `models/` and `repository/` (protocols), plus pure logic (reward parsing, anniversaries, profanity rules) as one type per file.
- **`presentation/`** — feature folders (`intro`, `home`, `details`, `map`, `tours`, `info`, `more`, `favorites`, `myrequests`, `submission`, `feedback`, `navigation`, `admin/*`, `common`), each with `ui/`, `viewmodels/`, `models/`, `states/`.
- **`di/AppDIContainer.swift`** — the single composition root: every data source and repository is a `private lazy var`, and the `extension AppDIContainer` block exposes `buildXViewModel()` factories. No DI framework. Any new repository must be wired here.
- **`theme/`** — `Palette`, `Typography`, `Spacing`, `CornerRadius`.

Read-once caches (`Veterans`, `Burials`, `Tours`) live in actors with `invalidate()`; the content editor invalidates after every admin write. Offline persistence is enabled on `Database`. Local state is `UserDefaults` with the Android DataStore key names.

### Presentation pattern

- ViewModels are `@Observable final class`, hold collaborators as `@ObservationIgnored private let`, and expose a single `private(set) var xUiState` enum (`.loading` / `.success(data:)` / `.error`) plus a `XUiData` struct, and an `onAction(_:)` taking the feature's `XUserAction` enum (the Android `UiIntent`).
- Live data comes as Combine publishers from repositories; pipelines are built in `init` (`observeXUiState()`), `.receive(on: DispatchQueue.main)`, stored in `cancellables`. One-shot loads are `async` and started from the route's `.task`.
- Each screen file has **two** views: `XRoute` switches on the UI state and owns the ViewModel; `XScreen` is a pure view taking plain data + closures (and carries `#Preview`). Screens take no ViewModel.
- UI events travel up as closures or a `UserAction` enum, never by calling the router from a screen.

### Navigation

Follow Apple's tab pattern: a system `TabView` whose every tab owns its own `NavigationStack`, so the tab bar stays visible while pushing, and system navigation bars (large titles on tab roots, inline titles on pushed screens, native back button and swipe back). One global router, `MainRouter` (`presentation/navigation/main/MainRouter.swift`, conforming to `Router`), keeps the selected tab and a `NavigationPath` per tab; `push` appends to the selected tab's path.

Destinations are `Hashable` enums (`VeteranDestination`, `MapDestination`, `MoreDestination`, `AdminDestination`). Every `.navigationDestination(for:)` lives in a per-feature `ViewModifier`, and `AppNavigationDestinations` applies all of them once to the root of each tab's stack. Tabs: veterans, map, about, more, admin (only while the session is admin). Deep links (`https://chatroom-85fb8.web.app/veteran/{id}`, also the QR payload and notification taps) go through `DeepLinkCenter` → `VeteranLink.parseVeteranId` and push the details destination on the veterans tab; a launch from a link skips the intro.

## Conventions

- Swift concurrency: the project builds with `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and `SWIFT_APPROACHABLE_CONCURRENCY = YES` (Swift 5 language mode). Background types are explicitly marked `nonisolated`, `actor`, or `@unchecked Sendable`.
- Design follows Apple's Human Interface Guidelines, not the Android/Material look: system tab bar and navigation bars, `List`/`Form` (insetGrouped) for lists, settings, forms and admin editors, `.searchable`, toolbar buttons (Save as `.confirmationAction`, add as `+`), `ContentUnavailableView` for empty states, sheets with detents, swipe actions, `Stepper`/`Picker`/`Toggle`/`DatePicker` instead of custom controls. Content pages (veteran card, About) use a stretchy hero under a transparent navigation bar and grouped cards (`cardBackground()`).
- Theming: never hardcode colors, fonts, spacing or shadows. Use the tokens in `theme/` — `Palette` (iOS semantic colors plus the brand accent `Primary` from the asset catalog), `Typography` applied with `.appStyle(...)` (the system SF font through Dynamic Type text styles; no custom fonts), `Spacing`, `CornerRadius`, `Shadow`. The user picks system/light/dark and text size in More; the root applies them with `preferredColorScheme` and `dynamicTypeSize`.
- Icons: prefer SF Symbols. The only imagesets are photos, reward medals, news logos, the map marker and the app icon.
- Naming: this is a port of an Android app, so avoid carrying Compose/Material vocabulary back in. No `Scaffold`, `Dimens`, `Block`, `Pill`, `Chip`, `Widget` in type names; no `containerColor`/`contentColor`/`elevation` parameters (use `background`/`foreground`/`shadowRadius`); no `XxxDefaults` constant holders (use `private static let`, or a file-private `enum XMetrics`); no SCREAMING_SNAKE constants; no `get`-prefixed accessors. Design-system types carry no prefix — only `AppButton`/`AppButtonStyle` do.
- Files under `OurMemory/` and `OurMemoryTests/` are picked up by `xcodegen generate`; rerun it (and `pod install`) after adding files.
