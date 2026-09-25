import Foundation

enum InfoContent {
    private static let paragraphSeparator = "\n\n"
    private static let routeUrl = "https://yandex.ru/maps/?rtext=~"
    private static let newsSources = [
        (
            "tochkaNews",
            "Tochka.by",
            "https://tochka.by/articles/life/muzey_pod_otkrytym_nebom_chem_vas_mozhet_udivit_voennoe_kladbishche/"
        ),
        (
            "sbByNews",
            "SB.by",
            "https://news.sb.by/articles/na-karte-minska-poyavilas-eshche-odna-tsifrovaya-zvezda-pamyatnuyu-tablichku-ustanovili-na-voennom-k.html"
        ),
        (
            "minskNews",
            "Minsknews.by",
            "https://minsknews.by/lyudi-zhivy-do-teh-por-poka-o-nih-pomnyat-istoriya-voennogo-kladbishha-v-minske/"
        )
    ]

    static var news: [NewsUi] {
        return newsSources.compactMap { imageName, title, link in
            return URL(string: link).map { return NewsUi(imageName: imageName, title: title, url: $0) }
        }
    }

    static var routeToCemetery: URL? {
        return URL(string: "\(routeUrl)\(CemeteryLocation.latitude),\(CemeteryLocation.longitude)")
    }

    static func historyParagraphs() -> [String] {
        return L10n.string("information")
            .components(separatedBy: paragraphSeparator)
            .map { return $0.trimmed }
            .filter { return !$0.isEmpty }
    }
}
