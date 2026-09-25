import SwiftUI

struct FeedbackRoute: View {
    @State private var viewModel: FeedbackViewModel
    let onClose: () -> Void

    init(viewModel: FeedbackViewModel, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onClose = onClose
    }

    var body: some View {
        let data = viewModel.feedbackUiData
        return Group {
            if data.status == .sent {
                SentView(message: "thank_you_message_sent_msg", onDone: onClose)
            } else {
                FeedbackScreen(data: data, onAction: viewModel.onAction)
            }
        }
        .navigationTitle(data.isAboutVeteran ? "report_an_error" : "write_to_us")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(data.status == .sent)
        .task { await viewModel.loadVeteranName() }
    }
}
