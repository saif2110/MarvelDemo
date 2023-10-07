

import Foundation

// MARK: - Characters

struct Characters: Codable {
    var code: Int?
    var status, copyright, attributionText, attributionHTML: String?
    var etag: String?
    var data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var offset, limit, total, count: Int?
    var results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    var id: Int?
    var name, description: String?
    var modified: String?
    var thumbnail: Thumbnail?
    var resourceURI: String?
    var comics, series: Comics?
    var events: Comics?
    var urls: [URLElement]?
}

// MARK: - Comics
struct Comics: Codable {
    var available: Int?
    var collectionURI: String?
    var items: [ComicsItem]?
    var returned: Int?
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    var resourceURI: String?
    var name: String?
}

// MARK: - Stories
//struct Stories: Codable {
//    var available: Int?
//    var collectionURI: String?
//    var items: [StoriesItem]?
//    var returned: Int?
//}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    var resourceURI: String?
    var name: String?
    var type: TypeEnum?
}

enum TypeEnum: String, Codable {
    case cover = "cover"
    case interiorStory = "interiorStory"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    var path: String?
    var thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    var type: String?
    var url: String?
}
