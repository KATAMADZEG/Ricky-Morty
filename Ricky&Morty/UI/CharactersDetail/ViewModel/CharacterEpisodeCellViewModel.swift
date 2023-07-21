//
//  CharacterEpisodeCellViewModel.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/20/23.
//

import Foundation

protocol EpisodeDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class CharacterEpisodeCellViewModel {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((EpisodeDataRender) -> Void)?
    
    private var episode: EpisodeModel? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
        
    }
    // MARK: - Public
    public func registerForData(_ block: @escaping (EpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() async {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        
        isFetching = true
        guard let url = episodeDataUrl,
              let request = RequestApi(url: url) else {
            return
        }
        
        let result  = try? await Service.shared.execute(request, expecting: EpisodeModel.self)
        switch result {
        case .success(let model):
            DispatchQueue.main.async {
                self.episode = model
            }
        case .failure(let failure):
            print(String(describing: failure))
        case .none:
            break
        }
    }
}
