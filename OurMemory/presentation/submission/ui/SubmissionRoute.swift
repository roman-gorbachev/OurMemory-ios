import SwiftUI

struct SubmissionRoute: View {
    @State private var viewModel: SubmissionViewModel
    let onClose: () -> Void

    init(viewModel: SubmissionViewModel, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onClose = onClose
    }

    var body: some View {
        let data = viewModel.submissionUiData
        return Group {
            if data.status == .sent {
                SentView(message: "thank_you_material_sent_msg", onDone: onClose)
            } else {
                SubmissionScreen(data: data, onAction: viewModel.onAction)
            }
        }
        .navigationTitle("add_to_history")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(data.status == .sent)
        .task { await viewModel.loadVeteranName() }
    }
}
