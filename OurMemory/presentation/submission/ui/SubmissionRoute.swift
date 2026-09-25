import SwiftUI

struct SubmissionRoute: View {
    @State private var viewModel: SubmissionViewModel
    let onBack: () -> Void

    init(viewModel: SubmissionViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("add_to_history"), onBack: onBack) {
            if viewModel.submissionUiData.status == .sent {
                SentView(message: "thank_you_material_sent_msg", onDone: onBack)
            } else {
                SubmissionScreen(data: viewModel.submissionUiData, onAction: viewModel.onAction)
            }
        }
        .task { await viewModel.loadVeteranName() }
    }
}
