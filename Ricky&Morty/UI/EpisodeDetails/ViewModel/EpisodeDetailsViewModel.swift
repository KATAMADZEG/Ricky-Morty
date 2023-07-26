////
////  EpisodeDetailsViewModel.swift
////  Ricky&Morty
////
////  Created by MacUser on 21.07.23.
////
//
import Foundation

protocol EpisodeDetailsViewModelType {
    var input: EpisodeDetailsViewModelInput { get }
    var output: EpisodeDetailsViewModelOutput? { get }
}
protocol EpisodeDetailsViewModelInput {
    func getEpisodeDetails() async
}
protocol EpisodeDetailsViewModelOutput {
    func episodeDetailsResponse(response: Result<EpisodeModel, Error>?) async
}

final class EpisodeDetailsViewModel: EpisodeDetailsViewModelType {
    
    var input: EpisodeDetailsViewModelInput { self }
    var output: EpisodeDetailsViewModelOutput?
    
    var endpointUrl: String? = ""
    var episodeDetailModel = [FillEpisodeDetailModel]()
    
}
//MARK: - EpisodeDetailsViewModelInput
extension EpisodeDetailsViewModel: EpisodeDetailsViewModelInput {
    func getEpisodeDetails() async {
        guard let url = endpointUrl,
              let request = RequestApi(url: URL(string: url)!) else {
            return
        }
        let result = try? await Service.shared.execute(request, expecting: EpisodeModel.self)
        await output?.episodeDetailsResponse(response: result)
    }
}
