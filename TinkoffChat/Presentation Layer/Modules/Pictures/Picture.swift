//
//  Picture.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

struct Picture: Codable {
  let previewUrl: String
  let largeImageUrl: String
  
  enum CodingKeys: String, CodingKey {
    case previewUrl = "previewURL"
    case largeImageUrl = "largeImageURL"
  }
  
}
