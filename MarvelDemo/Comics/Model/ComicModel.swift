//
//  ComicModel.swift
//  MarvelDemo
//
//  Created by Admin on 07/10/23.
//


import Foundation


class ComicModel {
    
   struct Comics: Codable {
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
        var id:Int?
        var digitalID :Int?
        var title: String?
        var variantDescription, description, modified, isbn: String?
        var upc, diamondCode, ean, issn: String?
        var format:String?
        var pageCount: Int?
        var textObjects: [TextObject]?
        var resourceURI: String?
        var urls: [URLElement]?
        var series: Series?
        var variants, collections, collectedIssues: [Series]?
        var dates: [DateElement]?
        var thumbnail: Thumbnail?
        var images: [Thumbnail]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case digitalID = "digitalId"
            case title, variantDescription, description, modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, urls, series, variants, collections, collectedIssues, dates, thumbnail, images
        }
    }
    
    // MARK: - CharactersClass
    struct CharactersClass: Codable {
        var available, returned, collectionURI: String?
        var items: [CharactersItem]?
    }
    
    // MARK: - CharactersItem
    struct CharactersItem: Codable {
        var resourceURI, name, role: String?
    }
    
    // MARK: - Series
    struct Series: Codable {
        var resourceURI, name: String?
    }
    
    // MARK: - DateElement
    struct DateElement: Codable {
        var type, date: String?
    }
    
    // MARK: - Events
    struct Events: Codable {
        var available, returned, collectionURI: String?
        var items: [Series]?
    }
    
    // MARK: - Thumbnail
    struct Thumbnail: Codable {
        var path, thumbnailExtension: String?
        
        enum CodingKeys: String, CodingKey {
            case path
            case thumbnailExtension = "extension"
        }
    }
    
    // MARK: - Price
    struct Price: Codable {
        var type, price: String?
    }
    
    // MARK: - Stories
//    struct Stories: Codable {
//        var available, returned, collectionURI: String?
//        var items: [StoriesItem]?
//    }
    
    // MARK: - StoriesItem
    struct StoriesItem: Codable {
        var resourceURI, name, type: String?
    }
    
    // MARK: - TextObject
    struct TextObject: Codable {
        var type, language, text: String?
    }
    
    // MARK: - URLElement
    struct URLElement: Codable {
        var type, url: String?
    }
    
}
