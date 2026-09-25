import Combine
import Foundation
import UserNotifications

final class FavoriteAnniversaryScheduler {
    private static let reminderHour = 10
    private static let maxScheduled = 60

    private let center: UNUserNotificationCenter
    private let veteransRepository: VeteransRepository
    private let favoritesRepository: FavoritesRepository
    private let settingsRepository: SettingsRepository
    private var cancellable: AnyCancellable?
    private var scheduleTask: Task<Void, Never>?

    init(
        center: UNUserNotificationCenter,
        veteransRepository: VeteransRepository,
        favoritesRepository: FavoritesRepository,
        settingsRepository: SettingsRepository
    ) {
        self.center = center
        self.veteransRepository = veteransRepository
        self.favoritesRepository = favoritesRepository
        self.settingsRepository = settingsRepository
    }

    func start() {
        cancellable = favoritesRepository.favoritesPublisher()
            .combineLatest(settingsRepository.settingsPublisher().map { return ($0.favoriteReminders, $0.language) }
                .removeDuplicates { return $0 == $1 })
            .sink { [weak self] favorites, settings in
                self?.schedule(favorites: favorites, isEnabled: settings.0)
            }
    }

    private func schedule(favorites: Set<String>, isEnabled: Bool) {
        scheduleTask?.cancel()
        scheduleTask = Task { [weak self] in
            guard let self else {
                return
            }
            await removeScheduled()
            guard isEnabled, !favorites.isEmpty, let veterans = try? await veteransRepository.allVeterans() else {
                return
            }
            let requests = veterans
                .filter { return favorites.contains($0.id) }
                .flatMap { return self.requests(for: $0) }
                .prefix(Self.maxScheduled)
            for request in requests where !Task.isCancelled {
                try? await center.add(request)
            }
        }
    }

    private func removeScheduled() async {
        let pending = await center.pendingNotificationRequests()
        let ids = pending.map(\.identifier).filter { return $0.hasPrefix(ReminderNotifications.anniversaryIdPrefix) }
        center.removePendingNotificationRequests(withIdentifiers: ids)
    }

    private func requests(for veteran: Veteran) -> [UNNotificationRequest] {
        return [
            request(for: veteran, date: veteran.birthDate, kind: .birthday),
            request(for: veteran, date: veteran.deathDate, kind: .memoryDay)
        ]
        .compactMap { return $0 }
    }

    private func request(for veteran: Veteran, date: String, kind: AnniversaryKind) -> UNNotificationRequest? {
        guard let parsed = IsoDate(date) else {
            return nil
        }
        let content = UNMutableNotificationContent()
        content.title = veteran.name
        content.body = L10n.format(kind == .birthday ? "birthday_in_year" : "day_of_memory_in_year", parsed.year)
        content.sound = .default
        content.userInfo = [ReminderNotifications.veteranIdKey: veteran.id]
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(month: parsed.month, day: parsed.day, hour: Self.reminderHour),
            repeats: true
        )
        let id = "\(ReminderNotifications.anniversaryIdPrefix)\(veteran.id)_\(kind.rawValue)"
        return UNNotificationRequest(identifier: id, content: content, trigger: trigger)
    }
}
