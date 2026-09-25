import XCTest
@testable import OurMemory

final class SettingsRepositoryImplTests: XCTestCase {
    private var suiteName = ""
    private var defaults = UserDefaults.standard

    override func setUp() {
        super.setUp()
        suiteName = "SettingsRepositoryImplTests-\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName) ?? .standard
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    func testDefaultsFollowSystemWithRemindersOn() async throws {
        let repository = SettingsRepositoryImpl(preferences: PreferencesStore(defaults: defaults))
        let settings = try await repository.settingsPublisher().firstValue()
        XCTAssertEqual(settings, AppSettings())
    }

    func testChangesArePersisted() async throws {
        let repository = SettingsRepositoryImpl(preferences: PreferencesStore(defaults: defaults))
        repository.setThemeMode(.dark)
        repository.setTextScale(.extraLarge)
        repository.setVictoryDayReminder(isEnabled: false)
        let settings = try await SettingsRepositoryImpl(preferences: PreferencesStore(defaults: defaults))
            .settingsPublisher()
            .firstValue()
        XCTAssertEqual(settings.themeMode, .dark)
        XCTAssertEqual(settings.textScale, .extraLarge)
        XCTAssertFalse(settings.victoryDayReminder)
        XCTAssertTrue(settings.favoriteReminders)
    }
}
