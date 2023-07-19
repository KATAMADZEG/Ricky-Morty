//
//  CharactersViewModel.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import Foundation

protocol CharactersViewModelType {
  var input: CharactersViewModelInput { get }
  var output: CharactersViewModelOutput? { get }
}
protocol CharactersViewModelInput {
  func getCharacters() async
  func fetchAdditionalCharacters(url: URL) async
}
protocol CharactersViewModelOutput {
  func charactersResponse(response: Result<CharactersModel, Error>?) async
  func additionalCharactersResponse(response: Result<CharactersModel, Error>?) async
}

final class CharactersViewModel: CharactersViewModelType {
  
  var input: CharactersViewModelInput { self }
  var output: CharactersViewModelOutput?
  
  var characters: CharactersModel?
  
  var shouldShowLoadMoreIndicator: Bool { 
    return characters?.info?.next != nil
  }
  var isLoadingMoreCharacters = false
  
}
//MARK: - CharactersViewModelInput
extension CharactersViewModel: CharactersViewModelInput {
  func fetchAdditionalCharacters(url: URL) async {
    guard !isLoadingMoreCharacters else {
      return
    }
    isLoadingMoreCharacters = true
    guard let request = RequestApi(url: url) else {
      isLoadingMoreCharacters = false
      return
    }
    let result  = try? await Service.shared.execute(request, expecting: CharactersModel.self)
    await output?.additionalCharactersResponse(response: result)

  }
  
  func getCharacters() async {
    let response  = try? await Service.shared.execute(.listCharactersRequests, expecting: CharactersModel.self)
    await output?.charactersResponse(response: response)
  }
}
