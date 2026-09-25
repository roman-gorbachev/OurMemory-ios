import SwiftUI

struct AdminNavigationDestinations: ViewModifier {
    let container: AppDIContainer
    let router: MainRouter

    func body(content: Content) -> some View {
        return content.navigationDestination(for: AdminDestination.self) { destination in
            switch destination {
            case .guide(let section):
                EditorGuideScreen(initialSection: section, onBack: router.pop)
            case .feedback:
                FeedbackListRoute(
                    viewModel: container.buildFeedbackListViewModel(),
                    onBack: router.pop,
                    onVeteranOpen: { router.push(VeteranDestination.details(veteranId: $0)) }
                )
            case .moderation:
                ModerationListRoute(
                    viewModel: container.buildModerationListViewModel(),
                    onBack: router.pop,
                    onSubmissionOpen: { router.push(AdminDestination.submission(submissionId: $0)) }
                )
            case .submission(let submissionId):
                SubmissionReviewRoute(viewModel: container.buildSubmissionReviewViewModel(submissionId: submissionId), onBack: router.pop)
            case .veterans:
                AdminVeteransRoute(viewModel: container.buildAdminVeteransViewModel(), onBack: router.pop, onOpen: router.push)
            case .veteranEditor(let veteranId):
                VeteranEditorRoute(viewModel: container.buildVeteranEditorViewModel(veteranId: veteranId), onBack: router.pop)
            case .burials:
                AdminBurialsRoute(viewModel: container.buildAdminBurialsViewModel(), onBack: router.pop, onOpen: router.push)
            case .burialEditor(let burialId):
                BurialEditorRoute(viewModel: container.buildBurialEditorViewModel(burialId: burialId), onBack: router.pop)
            case .tours:
                AdminToursRoute(viewModel: container.buildAdminToursViewModel(), onBack: router.pop, onOpen: router.push)
            case .tourEditor(let tourId):
                TourEditorRoute(viewModel: container.buildTourEditorViewModel(tourId: tourId), onBack: router.pop)
            }
        }
    }
}
