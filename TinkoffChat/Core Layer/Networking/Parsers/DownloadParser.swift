//
//  DownloadParser.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

class DownloadImageParser: IParser {
  typealias Model = UIImage
  
  func parse(data: Data) -> Model? {
    guard let image = UIImage(data: data) else { return nil }
    return image
  }
  
}
