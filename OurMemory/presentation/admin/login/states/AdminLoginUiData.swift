import Foundation

struct AdminLoginUiData: Hashable {
    var email = ""
    var password = ""
    var isSigningIn = false
    var isSignedIn = false
    var error: AdminLoginError?

    var canSignIn: Bool {
        return !email.isBlank && !password.isEmpty && !isSigningIn
    }
}
