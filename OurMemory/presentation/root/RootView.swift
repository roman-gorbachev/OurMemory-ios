import SwiftUI

struct RootView: View {
    @State private var viewModel: RootViewModel
    @State private var isIntroShown = true
    private let container: AppDIContainer
    private let deepLinks = DeepLinkCenter.shared

    init(container: AppDIContainer) {
        self.container = container
        _viewModel = State(initialValue: container.buildRootViewModel())
    }

    var body: some View {
        let settings = viewModel.settings
        return ZStack {
            if isIntroShown && deepLinks.pendingVeteranId == nil {
                IntroScreen { isIntroShown = false }
                    .transition(.opacity)
            } else {
                MainNavigationView(
                    container: container,
                    isAdmin: viewModel.isAdmin,
                    language: settings.language,
                    onLanguageChange: viewModel.setLanguage
                )
            }
        }
        .animation(.easeInOut, value: isIntroShown)
        .id(settings.language)
        .environment(\.locale, L10n.locale)
        .preferredColorScheme(settings.themeMode.colorScheme)
        .modifier(DynamicTypeModifier(size: settings.textScale.dynamicTypeSize))
        .tint(Palette.primary)
    }
}

private struct DynamicTypeModifier: ViewModifier {
    let size: DynamicTypeSize?

    func body(content: Content) -> some View {
        if let size {
            content.dynamicTypeSize(size)
        } else {
            content
        }
    }
}
