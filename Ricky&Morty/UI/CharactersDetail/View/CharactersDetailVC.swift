//
//  CharactersDetailVC.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import UIKit

final class CharactersDetailVC: UIViewController {

  private let viewModel: CharactersDetailsViewModel
  private var collectionView: UICollectionView?
  // MARK: - Init
  init(viewModel: CharactersDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)

  }

  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }
  //MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    collectionView = createCollectionView()
    collectionView?.delegate = self
    collectionView?.dataSource = self
    addConstraints()
  }
  //MARK: - Helpers
  private func createCollectionView() -> UICollectionView {
      let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
          return self.createSection(for: sectionIndex)
      }
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.register(CharactersPhotoCell.self,
                              forCellWithReuseIdentifier: CharactersPhotoCell.cellIdentifer)
      collectionView.register(CharactersInfoCell.self,
                              forCellWithReuseIdentifier: CharactersInfoCell.cellIdentifer)
      collectionView.register(CharacterEpisodeCell.self,
                              forCellWithReuseIdentifier: CharacterEpisodeCell.cellIdentifer)
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      return collectionView
  }

  private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
      let sectionTypes = viewModel.sections
      switch sectionTypes[sectionIndex]  {
      case .photo:
          return viewModel.createPhotoSectionLayout()
      case .information:
          return viewModel.createInfoSectionLayout()
      case .episodes:
          return viewModel.createEpisodeSectionLayout()
      }
  }

  private func addConstraints() {
    guard let collectionView = collectionView else {
      return
    }

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CharactersDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return viewModel.sections.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      let sectionType = viewModel.sections[section]
      switch sectionType {
      case .photo:
          return 1
      case .information(let viewModels):
          return viewModels.count
      case .episodes: //droebit
        return 1
//          return viewModels.count
      }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let sectionType = viewModel.sections[indexPath.section]
      switch sectionType {
      case .photo(let viewModel):
          guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: CharactersPhotoCell.cellIdentifer,
              for: indexPath
          ) as? CharactersPhotoCell else {
              fatalError()
          }
//          cell.configure(with: viewModel)
          return cell
      case .information(let viewModels):
          guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: CharactersInfoCell.cellIdentifer,
              for: indexPath
          ) as? CharactersInfoCell else {
              fatalError()
          }
//          cell.configure(with: viewModels[indexPath.row])
          return cell
      case .episodes: // droebittt
          guard let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: CharacterEpisodeCell.cellIdentifer,
              for: indexPath
          ) as? CharacterEpisodeCell else {
              fatalError()
          }
//          let viewModel = viewModels[indexPath.row]
//          cell.configure(with: viewModel)
          return cell
      }
  }

}
