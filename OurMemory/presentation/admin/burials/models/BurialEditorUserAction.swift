import Foundation

enum BurialEditorUserAction {
    case typeChanged(BurialType)
    case sectionChanged(String)
    case rowChanged(String)
    case placeChanged(String)
    case descriptionChanged(String)
    case latitudeChanged(String)
    case longitudeChanged(String)
    case pointPicked(latitude: Double, longitude: Double)
    case photoPicked(Data)
    case photoRemoved
    case save
}
