import SwiftUI

struct FeedbackRoute: View {
    @State private var viewModel: FeedbackViewModel
    let onBack: () -> Void

    init(viewModel: FeedbackViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        let data = viewModel.feedbackUiData
        return TopBarContainer(title: L10n.string(data.isAboutVeteran ? "report_an_error" : "write_to_us"), onBack: onBack) {
            if data.status == .sent {
                SentView(message: "thank_you_message_sent_msg", onDone: onBack)
            } else {
                FeedbackScreen(data: data, onAction: viewModel.onAction)
            }
        }
        .task { await viewModel.loadVeteranName() }
    }
}
