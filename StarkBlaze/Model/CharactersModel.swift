//
//  CharactersModel.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import Foundation


// MARK: - Characters Model
struct CharactersModel: Codable {
    var url: String
    var name: String
    var gender: String
    var culture: String
    var born: String
    var died: String
    var titles: [String]
    var aliases: [String]
    var father: String
    var mother: String
    var spouse: String
    var allegiances: [String]
    var books: [String]
    var povBooks: [String]
    var tvSeries: [String]
    var playedBy: [String]
    
    enum CodingKeys: String, CodingKey {
            case url
            case name
            case gender
            case culture
            case born
            case died
            case titles
            case aliases
            case father
            case mother
            case spouse
            case allegiances
            case books
            case povBooks
            case tvSeries
            case playedBy
        }
}

typealias characters = [CharactersModel]
