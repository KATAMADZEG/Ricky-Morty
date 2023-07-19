//
//  Extension + UIKit.swift
//  Ricky&Morty
//
//  Created by Giorgi Katamadze on 7/19/23.
//

import UIKit

extension UIView {

  func addSubviews(_ views: UIView...) {
    views.forEach({
      addSubview($0)
    })
  }
}

extension UIDevice {
  static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}
