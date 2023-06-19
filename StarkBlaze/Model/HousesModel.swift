//
//  HousesModel.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/18.
//

import Foundation

// MARK: - Houses Model
struct HousesModel: Codable {
    var url: String
    var name: String
    var region: String
    var coatOfArms: String
    var words: String
    var titles: [String]
    var seats: [String]
    var currentLord: String
    var heir: String
    var overlord: String
    var founded: String
    var founder: String
    var diedOut: String
    var ancestralWeapons: [String]
    var cadetBranches: [String]
    var swornMembers: [String]

    enum CodingKeys: String, CodingKey {
        case url
        case name
        case region
        case coatOfArms
        case words
        case titles
        case seats
        case currentLord
        case heir
        case overlord
        case founded
        case founder
        case diedOut
        case ancestralWeapons
        case cadetBranches
        case swornMembers
    }
}

typealias houses = [HousesModel]
