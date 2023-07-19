//
//  Service.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import Foundation

final class Service {
  static let shared = Service()
  private let cacheManager = CasheManager()

  private init() {}

  enum ServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
  }

  public func execute<T: Codable>(_ request: RequestApi, expecting type: T.Type) async throws -> (Result<T, Error>) {

    if let cachedData = cacheManager.cachedResponse(
      for: request.endpoint,
      url: request.url
    ) {
      do {
        let result = try JSONDecoder().decode(type.self, from: cachedData)
        return (.success(result))

      }
      catch {
        return (.failure(error))
      }
    }
    guard let urlRequest = self.request(from: request) else {
      return (.failure(ServiceError.failedToCreateRequest))

    }

    let (data, _) = try await URLSession.shared.data(from: urlRequest.url!)
    // Decode response
    do {
      let result = try JSONDecoder().decode(type.self, from: data)
      cacheManager.setCache(
        for: request.endpoint,
        url: request.url,
        data: data
      )
      return (.success(result))
    }
    catch {
      return (.failure(error))
    }
  }

  // MARK: - Private
  private func request(from rmRequest: RequestApi) -> URLRequest? {
    guard let url = rmRequest.url else {
      return nil
    }
    var request = URLRequest(url: url)
    request.httpMethod = rmRequest.httpMethod
    return request
  }

}
