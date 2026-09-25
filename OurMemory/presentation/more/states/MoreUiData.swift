import Foundation

struct MoreUiData: Hashable {
    var settings = AppSettings()
    var unseenRequestsCount = 0
    var account: VisitorAccount?
    var signInStatus = SignInStatus.idle
}
