//
//  CharactersModel.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import Foundation

// MARK: - CharactersModel
struct CharactersModel: Codable {
  let info: Info?
  var results: [Location]

}

// MARK: - Info
struct Info: Codable {
  let count, pages: Int?
  let next: String?
  let prev: String?
}
struct Location: Codable {
    let id: Int?
    let name: String?
    let status: String? 
    let type: String?
    let dimension: String?
    let residents: [String]?
    let episode: [String]?
    let image: String?
    let url: String?
    var location: Loc
    let created: String?
}

struct Loc: Codable {
  let name: String?
}
