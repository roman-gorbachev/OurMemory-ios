import Combine
import FirebaseDatabase

extension DatabaseQuery {
    func valuePublisher() -> AnyPublisher<DataSnapshot, Error> {
        return Deferred {
            let subject = PassthroughSubject<DataSnapshot, Error>()
            let handle = self.observe(
                .value,
                with: { snapshot in subject.send(snapshot) },
                withCancel: { error in subject.send(completion: .failure(error)) }
            )
            return subject.handleEvents(
                receiveCompletion: { _ in self.removeObserver(withHandle: handle) },
                receiveCancel: { self.removeObserver(withHandle: handle) }
            )
        }
        .eraseToAnyPublisher()
    }
}
