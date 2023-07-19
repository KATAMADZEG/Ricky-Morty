//
//  ImageLoader.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import Foundation


final class ImageLoader {
  //MARK: - Properties
  static let shared = ImageLoader()
  private var imageDataCache = NSCache<NSString, NSData>()

  enum DownloadError: Error {
    case downloadFailed(Error)
  }

  //MARK: - Init
  private init() {}

  public func downloadImage(_ url: URL) async throws -> Data {
    let key = url.absoluteString as NSString
    if let data = imageDataCache.object(forKey: key) as Data? {
      return data
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      // Cache the downloaded data
      imageDataCache.setObject(data as NSData, forKey: key)
      return data
    } catch {
      throw DownloadError.downloadFailed(error)
    }
  }
}
