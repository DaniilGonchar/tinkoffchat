//
//  PictureCell.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

class PictureCell: UICollectionViewCell, IPictureCellConfiguration {
  
  var previewUrl, largeImageUrl: String?
  
  @IBOutlet var imageView: UIImageView!
  
  func setup(image: UIImage, picture: Picture) {
    imageView.image = image
    previewUrl = picture.previewUrl
    largeImageUrl = picture.largeImageUrl
  }
  
}
