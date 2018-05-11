//
//  PictureServiceProtocols.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

protocol IPicturesService {
  
  func getPictures(completionHandler: @escaping ([Picture]?, String?) -> ())
  
  func downloadPicture(urlString: String, completionHandler: @escaping (UIImage?, String?) -> ())
  
}
