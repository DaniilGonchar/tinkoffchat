//
//  Requests.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

class SearchImagesRequest: IRequest {
  private let key: String
  
  private let baseLink = "https://pixabay.com/api/"
  
  private var parameters = ["q": "palm+sky", "image_type": "photo", "pretty": "true", "per_page": "200"]

  private var urlString: String {
    parameters["key"] = key
    
    var formingString = String()
    
    for pair in parameters {
      formingString.append("\(pair.key)=\(pair.value)&")
    }

    return String("\(baseLink)?\(formingString.dropLast())")
  }

  var urlRequest: URLRequest? {
    guard let url = URL(string: urlString) else { return nil }
    return URLRequest(url: url)
  }

  init(key: String) {
    self.key = key
  }

}



class DownloadImageRequest: IRequest {
  var urlString: String

  var urlRequest: URLRequest? {
    guard let url = URL(string: urlString) else { return nil }
    return URLRequest(url: url)
  }

  init(urlString: String) {
    self.urlString = urlString
  }

}
