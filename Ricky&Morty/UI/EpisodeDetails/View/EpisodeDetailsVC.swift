//
//  EpisodeDetailsVC.swift
//  Ricky&Morty
//
//  Created by MacUser on 21.07.23.
//

import UIKit

final class EpisodeDetailsVC: UIViewController{
    
    //MARK: - Properties
    private var viewModel = EpisodeDetailsViewModel()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(EpisodeDetailInfoCell.self, forCellWithReuseIdentifier: EpisodeDetailInfoCell.cellIdentifier)
        return collectionView
    }()
    // MARK: - Init
    init(url: String) {
        viewModel.endpointUrl = url
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        viewModel.output = self
        Task {
            await viewModel.input.getEpisodeDetails()
        }
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}
//MARK: - EpisodeDetailsViewModelOutput
extension EpisodeDetailsVC: EpisodeDetailsViewModelOutput {
    func episodeDetailsResponse(response: Result<EpisodeModel, Error>?) async {
        switch response {
        case .success(let data):
            viewModel.episodeDetailModel.removeAll()
            viewModel.episodeDetailModel.append(FillEpisodeDetailModel(title: "Episode Name", description: data.name))
            viewModel.episodeDetailModel.append(FillEpisodeDetailModel(title: "Air Date", description: data.air_date))
            viewModel.episodeDetailModel.append(FillEpisodeDetailModel(title: "Episode", description: data.episode))
            viewModel.episodeDetailModel.append(FillEpisodeDetailModel(title: "Created", description: data.created))
            collectionView.reloadData()
        case .failure(let failure):
            print(failure)
        case .none:
            break
        }
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension EpisodeDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print( viewModel.episodeDetailModel.count)
        return  viewModel.episodeDetailModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodeDetailInfoCell.cellIdentifier,
            for: indexPath
        ) as? EpisodeDetailInfoCell else {
            fatalError()
        }
        cell.configure(with: viewModel.episodeDetailModel[indexPath.row])
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension EpisodeDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.size.width, height: 80)
    }
}
