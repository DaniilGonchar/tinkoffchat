//
//  PicturesModel.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

class PicturesModel: IPicturesModel {
  private let picturesService: IPicturesService
  var data: [Picture] = []
  
  
  init(picturesService: IPicturesService) {
    self.picturesService = picturesService
  }
  
  
  func fetchPicture(urlString: String, completionHandler: @escaping (UIImage?) -> ()) {
    picturesService.downloadPicture(urlString: urlString) { image, error in
      
      guard let image = image else {
        return completionHandler(nil)
      }
      
      completionHandler(image)
    }
  }
  
  
  func fetchAllPictures(completionHandler: @escaping ([Picture]?, String?) -> ()) {
    picturesService.getPictures { pictures, errorText in
      
      guard let pictures = pictures else {
        completionHandler(nil, errorText)
        return
      }
      
      completionHandler(pictures, nil)
    }
  }
  
}
