//
//  PicturesProtocols.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

protocol ICollectionPickerController: class {
  func close()
}


protocol IPicturesViewControllerDelegate: class {
  func collectionPickerController(_ picker: ICollectionPickerController, didFinishPickingImage image: UIImage)
}


protocol IPictureCellConfiguration {
  var previewUrl: String? { get set }
  var largeImageUrl: String? { get set }
}


protocol IPicturesModel: class {
  var data: [Picture] { get set }
  
  func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> ())
  func fetchPicture(urlString: String, completionHandler: @escaping (UIImage?) -> ())
}


