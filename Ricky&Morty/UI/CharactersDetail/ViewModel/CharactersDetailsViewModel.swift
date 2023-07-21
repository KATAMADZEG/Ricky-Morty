//
//  CharactersDetailsView.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import UIKit

final class CharactersDetailsViewModel {

    private let results: Location
    
    enum SectionType {
        case photo(viewModel: CharacterPhotoCellViewModel)
        case information(viewModel: [CharacterInfoCellViewModel])
        case episodes(viewModel: [CharacterEpisodeCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    // MARK: - Init
    init(character: Location) {
        self.results = character
        setUpSections()
    }
    
    private func setUpSections() {
        sections = [.photo(viewModel: .init(imageUrl: URL(string: results.image!))),
                    .information(viewModel: [
                        .init(type: .status , value: results.status ?? ""),
                        .init(type: .location , value: results.location.name ?? ""),
                        .init(type: .created , value: results.created ?? ""),
                        .init(type: .episodeCount , value: "\(results.episode?.count ?? 0)"),
                    ]),
                    .episodes(viewModel: (results.episode?.compactMap({
                        return CharacterEpisodeCellViewModel(episodeDataUrl: URL(string: $0))
                    }))!)
        ]
        
    }
    
    private var requestUrl: URL? {
        return URL(string: results.url!)
    }
    
    public var title: String {
        (results.name?.uppercased())!
    }
    
    // MARK: - Layouts
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 0,
                                                     bottom: 10,
                                                     trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.5 : 0.25),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: UIDevice.isiPhone ? [item, item] : [item, item, item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    public func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 5,
            bottom: 10,
            trailing: 8
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:  NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.8 : 0.4),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
