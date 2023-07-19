//
//  ViewController.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import UIKit

final class CharactersVC: UIViewController {
  //MARK: - Properties
  private let viewModel = CharactersViewModel()

  private let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(CharacterCollectionViewCell.self,
                            forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
    collectionView.register(FooterLoadingView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: FooterLoadingView.identifier)
    return collectionView
  }()

  //MARK: - LifeCycles
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    addConstraints()

    collectionView.delegate = self
    collectionView.dataSource = self

    viewModel.output = self
    Task { await viewModel.input.getCharacters() }

  }

  //MARK: - Helpers
  private func addConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

}
//MARK: - CharactersViewModelOutput
extension CharactersVC: CharactersViewModelOutput {

  func charactersResponse(response: Result<CharactersModel, Error>?) async {
    switch response {
    case .success(let data):
      viewModel.characters = data
      collectionView.reloadSections(IndexSet(integer: 0))
    case .failure(let failure):
      print(failure)
    case .none:
      break
    }
  }

  func additionalCharactersResponse(response: Result<CharactersModel, Error>?) async {

    switch response {
    case .success(let responseModel):
      let moreResults = responseModel.results
      let originalCount = viewModel.characters?.results.count
      let newCount = moreResults.count
      let total = (originalCount!) + (newCount)
      viewModel.characters?.results.append(contentsOf: moreResults)
      DispatchQueue.main.async { [self] in
        viewModel.isLoadingMoreCharacters = false
        collectionView.reloadSections(IndexSet(integer: 0))
      }
    case .failure(let failure):
      print(failure)
    case .none:
      break
    }
  }

}
//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CharactersVC:  UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    viewModel.characters?.results.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
      for: indexPath
    ) as? CharacterCollectionViewCell else {
      fatalError("Unsupported cell")
    }
    guard let curr =  viewModel.characters?.results[indexPath.row] else { return UICollectionViewCell() }

    cell.configure(with: curr)
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let curr = viewModel.characters?.results[indexPath.row]
    let viewModel = CharactersDetailsViewModel(character: curr!)
    let detailVC = CharactersDetailVC(viewModel: viewModel)
    navigationController?.pushViewController(detailVC, animated: true)
  }

}
//MARK: - UICollectionViewDelegateFlowLayout
extension CharactersVC: UICollectionViewDelegateFlowLayout {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard viewModel.shouldShowLoadMoreIndicator,
          !viewModel.isLoadingMoreCharacters,
          let nextUrlString = viewModel.characters?.info?.next,
          let url = URL(string: nextUrlString) else { return }

    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
      let offset = scrollView.contentOffset.y
      let totalContentHeight = scrollView.contentSize.height
      let totalScrollViewFixedHeight = scrollView.frame.size.height

      if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
        Task {

          await self?.viewModel.fetchAdditionalCharacters(url: url)
        }
      }
      t.invalidate()
    }

  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionFooter,
          let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FooterLoadingView.identifier,
            for: indexPath
          ) as? FooterLoadingView else {
      fatalError("Unsupported")
    }
    footer.startAnimating()
    return footer
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    guard viewModel.shouldShowLoadMoreIndicator else {
      return .zero
    }

    return CGSize(width: collectionView.frame.width,
                  height: 100)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let bounds = collectionView.bounds
    let width: CGFloat
    if UIDevice.isiPhone {
      width = (bounds.width-30)/2
    } else {
      // mac | ipad
      width = (bounds.width-50)/4
    }

    return CGSize(width: width, height: width * 1.5)
  }
}
