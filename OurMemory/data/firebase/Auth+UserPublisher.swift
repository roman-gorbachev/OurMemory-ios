import Combine
import FirebaseAuth

extension Auth {
    func userPublisher() -> AnyPublisher<User?, Never> {
        return Deferred {
            let subject = CurrentValueSubject<User?, Never>(self.currentUser)
            let handle = self.addStateDidChangeListener { _, user in
                subject.send(user)
            }
            return subject.handleEvents(receiveCancel: { self.removeStateDidChangeListener(handle) })
        }
        .eraseToAnyPublisher()
    }
}
