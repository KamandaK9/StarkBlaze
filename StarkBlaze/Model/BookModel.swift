//
//  BookModel.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import Foundation
import UIKit


//MARK: - Books Model
struct BookModel: Codable {
    var url: String
    var name: String
    var isbn: String
    var authors: [String]
    var numberOfPages: Int
    var publisher: String
    var country: String
    var mediaType: String
    var released: String
    var characters: [String]
    var povCharacters: [String]
    var backgroundColor: UIColor?
    
    enum CodingKeys: String, CodingKey {
        case url
        case name
        case isbn
        case authors
        case numberOfPages
        case publisher
        case country
        case mediaType
        case released
        case characters
        case povCharacters
    }
}

typealias books = [BookModel]
