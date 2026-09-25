import SwiftUI

protocol Router: AnyObject {
    var path: NavigationPath { get set }
    func push<Destination: Hashable>(_ destination: Destination)
    func pop()
    func popToRoot()
}
