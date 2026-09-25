import FirebaseCore
import GoogleSignIn
import UIKit

enum GoogleSignInLauncher {
    static func signIn() async -> MoreUserAction {
        guard let clientId = FirebaseApp.app()?.options.clientID, let presenter = topViewController() else {
            return .googleSignInFailed(.failed)
        }
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientId)
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presenter)
            guard let idToken = result.user.idToken?.tokenString else {
                return .googleSignInFailed(.failed)
            }
            return .googleTokensReceived(idToken: idToken, accessToken: result.user.accessToken.tokenString)
        } catch let error as NSError where error.code == GIDSignInError.canceled.rawValue {
            return .googleSignInFailed(.idle)
        } catch {
            return .googleSignInFailed(.failed)
        }
    }

    private static func topViewController() -> UIViewController? {
        let scene = UIApplication.shared.connectedScenes.compactMap { return $0 as? UIWindowScene }.first
        var controller = scene?.windows.first { return $0.isKeyWindow }?.rootViewController
        while let presented = controller?.presentedViewController {
            controller = presented
        }
        return controller
    }
}
