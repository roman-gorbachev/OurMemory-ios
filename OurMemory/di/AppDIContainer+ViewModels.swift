import Foundation

extension AppDIContainer {
    func buildRootViewModel() -> RootViewModel {
        return RootViewModel(settingsRepository: settingsRepository, authRepository: authRepository)
    }

    func buildHomeViewModel() -> HomeViewModel {
        return HomeViewModel(repository: veteransRepository, calendar: .current, now: Date.init)
    }

    func buildDetailsViewModel(veteranId: String) -> DetailsViewModel {
        return DetailsViewModel(
            veteranId: veteranId,
            veteransRepository: veteransRepository,
            burialsRepository: burialsRepository,
            audioRepository: makeAudioRepository(),
            candlesRepository: candlesRepository,
            settingsRepository: settingsRepository,
            favoritesRepository: favoritesRepository
        )
    }

    func buildMapViewModel(focusedBurialId: String?) -> MapViewModel {
        return MapViewModel(
            focusedBurialId: focusedBurialId,
            burialsRepository: burialsRepository,
            veteransRepository: veteransRepository,
            toursRepository: toursRepository,
            tourProgressRepository: tourProgressRepository
        )
    }

    func buildTourViewModel(tourId: String) -> TourViewModel {
        return TourViewModel(
            tourId: tourId,
            toursRepository: toursRepository,
            burialsRepository: burialsRepository,
            veteransRepository: veteransRepository,
            audioRepository: makeAudioRepository(),
            tourProgressRepository: tourProgressRepository
        )
    }

    func buildMoreViewModel() -> MoreViewModel {
        return MoreViewModel(
            settingsRepository: settingsRepository,
            reminderScheduler: reminderScheduler,
            visitorAccountRepository: visitorAccountRepository,
            myRequestsRepository: myRequestsRepository
        )
    }

    func buildFavoritesViewModel() -> FavoritesViewModel {
        return FavoritesViewModel(favoritesRepository: favoritesRepository, veteransRepository: veteransRepository)
    }

    func buildMyRequestsViewModel() -> MyRequestsViewModel {
        return MyRequestsViewModel(myRequestsRepository: myRequestsRepository, veteransRepository: veteransRepository)
    }

    func buildSubmissionViewModel(veteranId: String) -> SubmissionViewModel {
        return SubmissionViewModel(
            veteranId: veteranId,
            submissionsRepository: submissionsRepository,
            veteransRepository: veteransRepository,
            contentCheckRepository: contentCheckRepository
        )
    }

    func buildFeedbackViewModel(veteranId: String) -> FeedbackViewModel {
        return FeedbackViewModel(
            veteranId: veteranId,
            feedbackRepository: feedbackRepository,
            veteransRepository: veteransRepository,
            contentCheckRepository: contentCheckRepository
        )
    }
}
