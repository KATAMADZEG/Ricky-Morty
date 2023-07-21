//
//  CharacterPhotoCellViewModel.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import Foundation
import UIKit

final class CharacterPhotoCellViewModel {
    private let imageUrl: URL?
//
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
//
    public func fetchImage() async throws -> UIImage? {
        guard let imageUrl = imageUrl else {
            return nil
        }
        let data = try? await ImageLoader.shared.downloadImage(imageUrl)
        let image = UIImage(data: data!)
        
        return image
    }
}
