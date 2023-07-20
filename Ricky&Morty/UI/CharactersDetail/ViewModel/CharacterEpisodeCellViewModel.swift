//
//  CharacterEpisodeCellViewModel.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/20/23.
//

import Foundation

enum FetchError: Error {
    case invalidURL
    case fetchFailed
    case unknown
}

final class CharacterEpisodeCellViewModel {
  private var episodeDataUrl: URL? = nil

  init(episodeDataUrl: URL?) {
    self.episodeDataUrl = episodeDataUrl
  }
  public func fetchEpisode() async throws -> EpisodeModel {

    guard let url = episodeDataUrl,
          let request = RequestApi(url: url) else {
      throw FetchError.invalidURL
    }
//    print("\(episodeDataUrl?.absoluteString)")
    let result  = try? await Service.shared.execute(request, expecting: EpisodeModel.self)
    switch result {
    case .success(let model):
      return model

    case .failure(let failure):
      print(String(describing: failure))
      throw FetchError.fetchFailed
    case .none:
      throw FetchError.unknown
    }
  }
}
