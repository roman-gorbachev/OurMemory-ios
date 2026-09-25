import Combine
import Foundation

@Observable
final class AdminsViewModel {
    private(set) var adminsUiState = AdminsUiState.loading
    private(set) var addStatus = AddAdminStatus.idle

    @ObservationIgnored private let adminsRepository: AdminsRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    init(adminsRepository: AdminsRepository, authRepository: AuthRepository) {
        self.adminsRepository = adminsRepository
        observeAdminsUiState(authRepository: authRepository)
    }

    func onAction(_ action: AdminsUserAction) {
        switch action {
        case .add(let email):
            add(email: email.trimmed)
        case .remove(let uid):
            Task { try? await adminsRepository.removeAdmin(uid: uid) }
        case .addStatusShown:
            addStatus = .idle
        }
    }

    private func observeAdminsUiState(authRepository: AuthRepository) {
        adminsRepository.adminsPublisher()
            .combineLatest(authRepository.sessionPublisher().setFailureType(to: Error.self))
            .map { admins, session in
                return admins.map { admin in
                    return AdminItemUi(
                        uid: admin.uid,
                        email: admin.email,
                        isSuperAdmin: admin.isSuperAdmin,
                        isCurrentUser: admin.uid == session.uid
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.adminsUiState = .error
                    }
                },
                receiveValue: { [weak self] in self?.adminsUiState = .success(data: $0) }
            )
            .store(in: &cancellables)
    }

    private func add(email: String) {
        guard !email.isEmpty, addStatus != .adding else {
            return
        }
        addStatus = .adding
        Task {
            do {
                switch try await adminsRepository.addAdmin(email: email) {
                case .added:
                    addStatus = .added
                case .accountNotFound:
                    addStatus = .accountNotFound
                case .alreadyAdmin:
                    addStatus = .alreadyAdmin
                }
            } catch {
                addStatus = .failed
            }
        }
    }
}
