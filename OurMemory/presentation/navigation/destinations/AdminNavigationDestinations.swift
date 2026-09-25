import SwiftUI

struct AdminNavigationDestinations: ViewModifier {
    let container: AppDIContainer
    let router: MainRouter

    func body(content: Content) -> some View {
        return content.navigationDestination(for: AdminDestination.self) { destination in
            switch destination {
            case .guide(let section):
                EditorGuideScreen(initialSection: section)
            case .feedback:
                FeedbackListRoute(viewModel: container.buildFeedbackListViewModel(), onVeteranOpen: router.openVeteran)
            case .moderation:
                ModerationListRoute(viewModel: container.buildModerationListViewModel()) {
                    router.push(AdminDestination.submission(submissionId: $0))
                }
            case .submission(let submissionId):
                SubmissionReviewRoute(viewModel: container.buildSubmissionReviewViewModel(submissionId: submissionId), onClose: router.pop)
            case .veterans:
                AdminVeteransRoute(viewModel: container.buildAdminVeteransViewModel()) { router.push($0) }
            case .veteranEditor(let veteranId):
                VeteranEditorRoute(viewModel: container.buildVeteranEditorViewModel(veteranId: veteranId), onClose: router.pop)
            case .burials:
                AdminBurialsRoute(viewModel: container.buildAdminBurialsViewModel()) { router.push($0) }
            case .burialEditor(let burialId):
                BurialEditorRoute(viewModel: container.buildBurialEditorViewModel(burialId: burialId), onClose: router.pop)
            case .tours:
                AdminToursRoute(viewModel: container.buildAdminToursViewModel()) { router.push($0) }
            case .admins:
                AdminsRoute(viewModel: container.buildAdminsViewModel())
            case .tourEditor(let tourId):
                TourEditorRoute(viewModel: container.buildTourEditorViewModel(tourId: tourId), onClose: router.pop)
            }
        }
    }
}
