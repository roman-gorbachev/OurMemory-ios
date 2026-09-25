import Foundation

struct HomeUiData: Hashable {
    var veterans: [VeteranItemUi] = []
    var search = ""
    var checkedWar = true
    var checkedArt = true
    var anniversaries: [AnniversaryUi] = []
}
