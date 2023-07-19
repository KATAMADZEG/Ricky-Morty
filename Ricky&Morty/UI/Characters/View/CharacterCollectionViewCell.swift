//
//  CharacterCollectionViewCell.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
  static let cellIdentifier = "CharacterCollectionViewCell"
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .systemFont(ofSize: 18, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let statusLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.backgroundColor = .secondarySystemBackground
    contentView.addSubviews(imageView, nameLabel, statusLabel)
    addConstraints()
    setUpLayer()
  }
  
  required init?(coder: NSCoder) {
    fatalError("Unsupported")
  }
  
  private func setUpLayer() {
    contentView.layer.cornerRadius = 8
    contentView.layer.shadowColor = UIColor.label.cgColor
    contentView.layer.cornerRadius = 4
    contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
    contentView.layer.shadowOpacity = 0.3
  }
  
  private func addConstraints() {
    NSLayoutConstraint.activate([
      statusLabel.heightAnchor.constraint(equalToConstant: 30),
      nameLabel.heightAnchor.constraint(equalToConstant: 30),
      
      statusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
      statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
      nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
      nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
      
      statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
      nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),
      
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
    ])
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setUpLayer()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()

    imageView.image = nil
    nameLabel.text = nil
    statusLabel.text = nil
  }
  
  public func configure(with model: Location) {
    nameLabel.text = model.name ?? ""
    statusLabel.text = model.status ?? ""
    if let image = model.image {
      Task {
        let data = try? await ImageLoader.shared.downloadImage(URL(string: image)!)
        DispatchQueue.main.async {
          let image = UIImage(data: data!)
          self.imageView.image =  image
        }
      }
    }
  }
}
