import Foundation

@Observable
final class AdminLoginViewModel {
    private(set) var adminLoginUiData = AdminLoginUiData()

    @ObservationIgnored private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func onAction(_ action: AdminLoginUserAction) {
        switch action {
        case .emailChanged(let email):
            adminLoginUiData.email = email
            adminLoginUiData.error = nil
        case .passwordChanged(let password):
            adminLoginUiData.password = password
            adminLoginUiData.error = nil
        case .signIn:
            signIn()
        }
    }

    private func signIn() {
        let data = adminLoginUiData
        guard data.canSignIn else {
            return
        }
        adminLoginUiData.isSigningIn = true
        adminLoginUiData.error = nil
        Task {
            do {
                let result = try await authRepository.signIn(email: data.email.trimmed, password: data.password)
                adminLoginUiData.isSigningIn = false
                adminLoginUiData.isSignedIn = result == .admin
                switch result {
                case .admin:
                    adminLoginUiData.error = nil
                case .notAdmin:
                    adminLoginUiData.error = .noAdminRights
                case .wrongCredentials:
                    adminLoginUiData.error = .wrongCredentials
                }
            } catch {
                adminLoginUiData.isSigningIn = false
                adminLoginUiData.error = .connection
            }
        }
    }
}
