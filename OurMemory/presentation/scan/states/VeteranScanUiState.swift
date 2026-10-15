import Foundation

enum VeteranScanUiState {
    case loading
    case success(data: VeteranScanUiData)
    case error
}
