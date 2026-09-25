import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Foundation
import UserNotifications

@Observable
final class AppDIContainer {
    @ObservationIgnored private lazy var auth = Auth.auth()
    @ObservationIgnored private lazy var storage = Storage.storage()
    @ObservationIgnored private lazy var root = Database.database().reference(withPath: DatabaseNodes.root)
    @ObservationIgnored private lazy var preferences = PreferencesStore(defaults: .standard)
    @ObservationIgnored private lazy var calendar = Calendar.current
    @ObservationIgnored private lazy var anonymousSession = AnonymousSession(auth: auth)
    @ObservationIgnored private lazy var notificationCenter = UNUserNotificationCenter.current()

    @ObservationIgnored private lazy var favoritesLocalDataSource: FavoritesLocalDataSource =
        FavoritesLocalDataSourceImpl(preferences: preferences)
    @ObservationIgnored private lazy var favoritesRemoteDataSource: FavoritesRemoteDataSource =
        FavoritesRemoteDataSourceImpl(root: root)
    @ObservationIgnored private lazy var googleAccountDataSource: GoogleAccountDataSource =
        GoogleAccountDataSourceImpl(auth: auth)

    @ObservationIgnored lazy var veteransRepository: VeteransRepository = VeteransRepositoryImpl(
        dataSource: VeteransDataSourceImpl(root: root),
        yandexDisk: YandexDiskDataSourceImpl(session: .shared)
    )
    @ObservationIgnored lazy var burialsRepository: BurialsRepository =
        BurialsRepositoryImpl(dataSource: BurialsDataSourceImpl(root: root))
    @ObservationIgnored lazy var toursRepository: ToursRepository =
        ToursRepositoryImpl(dataSource: ToursDataSourceImpl(root: root))
    @ObservationIgnored lazy var tourProgressRepository: TourProgressRepository =
        TourProgressRepositoryImpl(preferences: preferences)
    @ObservationIgnored lazy var candlesRepository: CandlesRepository = CandlesRepositoryImpl(
        remoteDataSource: CandlesRemoteDataSourceImpl(root: root),
        localDataSource: CandlesLocalDataSourceImpl(preferences: preferences),
        calendar: calendar,
        now: Date.init
    )
    @ObservationIgnored lazy var favoritesRepository: FavoritesRepository = FavoritesRepositoryImpl(
        localDataSource: favoritesLocalDataSource,
        remoteDataSource: favoritesRemoteDataSource,
        accountDataSource: googleAccountDataSource
    )
    @ObservationIgnored lazy var visitorAccountRepository: VisitorAccountRepository = VisitorAccountRepositoryImpl(
        accountDataSource: googleAccountDataSource,
        favoritesLocalDataSource: favoritesLocalDataSource,
        favoritesRemoteDataSource: favoritesRemoteDataSource
    )
    @ObservationIgnored lazy var authRepository: AuthRepository =
        AuthRepositoryImpl(dataSource: AuthDataSourceImpl(auth: auth, root: root))
    @ObservationIgnored lazy var settingsRepository: SettingsRepository = SettingsRepositoryImpl(preferences: preferences)
    @ObservationIgnored lazy var myRequestsRepository: MyRequestsRepository = MyRequestsRepositoryImpl(
        dataSource: MyRequestsDataSourceImpl(auth: auth, root: root),
        seenDataSource: RequestsSeenLocalDataSource(preferences: preferences),
        now: Date.init
    )
    @ObservationIgnored lazy var feedbackRepository: FeedbackRepository = FeedbackRepositoryImpl(
        dataSource: FeedbackDataSourceImpl(anonymousSession: anonymousSession, root: root)
    )
    @ObservationIgnored lazy var submissionsRepository: SubmissionsRepository = SubmissionsRepositoryImpl(
        dataSource: SubmissionsDataSourceImpl(anonymousSession: anonymousSession, storage: storage, root: root)
    )
    @ObservationIgnored lazy var moderationRepository: ModerationRepository = ModerationRepositoryImpl(
        dataSource: ModerationDataSourceImpl(auth: auth, storage: storage, root: root),
        veteransRepository: veteransRepository
    )
    @ObservationIgnored lazy var contentEditorRepository: ContentEditorRepository = ContentEditorRepositoryImpl(
        dataSource: ContentDataSourceImpl(root: root),
        veteransRepository: veteransRepository,
        burialsRepository: burialsRepository,
        toursRepository: toursRepository
    )
    @ObservationIgnored lazy var mediaRepository: MediaRepository = MediaUploader(storage: storage)
    @ObservationIgnored lazy var contentCheckRepository: ContentCheckRepository = ContentCheckRepositoryImpl(
        profanityDetector: ProfanityDetector(),
        latinProfanityDetector: LatinProfanityDetector(),
        extremismDetector: ExtremismDetector(),
        imageClassifier: NsfwImageClassifier()
    )
    @ObservationIgnored lazy var reminderScheduler: ReminderScheduler = ReminderSchedulerImpl(center: notificationCenter)
    @ObservationIgnored lazy var audioPlayer = AudioPlayer()
    @ObservationIgnored private lazy var favoriteAnniversaryScheduler = FavoriteAnniversaryScheduler(
        center: notificationCenter,
        veteransRepository: veteransRepository,
        favoritesRepository: favoritesRepository,
        settingsRepository: settingsRepository
    )

    func startBackgroundWork() {
        favoriteAnniversaryScheduler.start()
    }

    func makeAudioRepository() -> AudioRepository {
        return AudioRepository(player: audioPlayer)
    }
}
