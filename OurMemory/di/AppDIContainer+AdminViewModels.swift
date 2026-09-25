import Foundation

extension AppDIContainer {
    func buildAdminLoginViewModel() -> AdminLoginViewModel {
        return AdminLoginViewModel(authRepository: authRepository)
    }

    func buildAdminHomeViewModel() -> AdminHomeViewModel {
        return AdminHomeViewModel(
            authRepository: authRepository,
            feedbackRepository: feedbackRepository,
            moderationRepository: moderationRepository,
            veteransRepository: veteransRepository,
            burialsRepository: burialsRepository,
            toursRepository: toursRepository
        )
    }

    func buildFeedbackListViewModel() -> FeedbackListViewModel {
        return FeedbackListViewModel(feedbackRepository: feedbackRepository, veteransRepository: veteransRepository)
    }

    func buildModerationListViewModel() -> ModerationListViewModel {
        return ModerationListViewModel(moderationRepository: moderationRepository, veteransRepository: veteransRepository)
    }

    func buildSubmissionReviewViewModel(submissionId: String) -> SubmissionReviewViewModel {
        return SubmissionReviewViewModel(
            submissionId: submissionId,
            moderationRepository: moderationRepository,
            veteransRepository: veteransRepository
        )
    }

    func buildAdminVeteransViewModel() -> AdminVeteransViewModel {
        return AdminVeteransViewModel(veteransRepository: veteransRepository)
    }

    func buildVeteranEditorViewModel(veteranId: String) -> VeteranEditorViewModel {
        return VeteranEditorViewModel(
            veteranId: veteranId,
            veteransRepository: veteransRepository,
            burialsRepository: burialsRepository,
            contentEditorRepository: contentEditorRepository,
            mediaRepository: mediaRepository,
            currentUid: authRepository.currentUid ?? ""
        )
    }

    func buildAdminBurialsViewModel() -> AdminBurialsViewModel {
        return AdminBurialsViewModel(burialsRepository: burialsRepository, veteransRepository: veteransRepository)
    }

    func buildBurialEditorViewModel(burialId: String) -> BurialEditorViewModel {
        return BurialEditorViewModel(
            burialId: burialId,
            burialsRepository: burialsRepository,
            contentEditorRepository: contentEditorRepository,
            mediaRepository: mediaRepository,
            currentUid: authRepository.currentUid ?? ""
        )
    }

    func buildAdminToursViewModel() -> AdminToursViewModel {
        return AdminToursViewModel(toursRepository: toursRepository)
    }

    func buildTourEditorViewModel(tourId: String) -> TourEditorViewModel {
        return TourEditorViewModel(
            tourId: tourId,
            toursRepository: toursRepository,
            burialsRepository: burialsRepository,
            veteransRepository: veteransRepository,
            contentEditorRepository: contentEditorRepository,
            mediaRepository: mediaRepository,
            currentUid: authRepository.currentUid ?? ""
        )
    }
}
