import SwiftUI

extension Reward {
    var imageName: String {
        switch self {
        case .redBanner:
            return "redZnamya"
        case .suvorovFirst, .suvorovSecond:
            return "suvorov1"
        case .lenin:
            return "lenin"
        case .heroUssr:
            return "gerojSssr"
        case .partisan:
            return "partizan"
        case .victoryOverGermany:
            return "zaPobeduGermany"
        case .patrioticWar:
            return "otechWar"
        case .redStar:
            return "redStar"
        case .badgeOfHonour:
            return "ordenZnakPocheta"
        case .forCourage:
            return "zaOtvagu"
        case .peoplesArtist:
            return "narodnyArtist"
        }
    }

    var nameKey: LocalizedStringKey {
        return LocalizedStringKey(nameResource)
    }

    var nameResource: String {
        switch self {
        case .redBanner:
            return "red_znamya"
        case .suvorovFirst:
            return "suvorov_1"
        case .suvorovSecond:
            return "suvorov_2"
        case .lenin:
            return "lenin"
        case .heroUssr:
            return "geroj_sssr"
        case .partisan:
            return "partizan"
        case .victoryOverGermany:
            return "za_pobedu_germany"
        case .patrioticWar:
            return "otech_war"
        case .redStar:
            return "red_star"
        case .badgeOfHonour:
            return "orden_znak_pocheta"
        case .forCourage:
            return "za_otvagu"
        case .peoplesArtist:
            return "narodny_artist"
        }
    }
}
