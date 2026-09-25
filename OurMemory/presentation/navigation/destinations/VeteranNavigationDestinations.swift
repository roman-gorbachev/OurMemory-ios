import SwiftUI

struct VeteranNavigationDestinations: ViewModifier {
    let container: AppDIContainer
    let router: MainRouter

    func body(content: Content) -> some View {
        return content.navigationDestination(for: VeteranDestination.self) { destination in
            switch destination {
            case .details(let veteranId):
                DetailsRoute(
                    viewModel: container.buildDetailsViewModel(veteranId: veteranId),
                    onBack: router.pop,
                    onShowOnMap: { router.push(MapDestination.burialMap(burialId: $0)) },
                    onAddToHistory: { router.push(VeteranDestination.submission(veteranId: veteranId)) },
                    onReportError: { router.push(VeteranDestination.feedback(veteranId: veteranId)) }
                )
            case .submission(let veteranId):
                SubmissionRoute(viewModel: container.buildSubmissionViewModel(veteranId: veteranId), onBack: router.pop)
            case .feedback(let veteranId):
                FeedbackRoute(viewModel: container.buildFeedbackViewModel(veteranId: veteranId), onBack: router.pop)
            }
        }
    }
}
