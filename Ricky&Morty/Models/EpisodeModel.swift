//
//  EpisodeModel.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/20/23.
//

import Foundation

struct EpisodeModel: Codable, EpisodeDataRender {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
