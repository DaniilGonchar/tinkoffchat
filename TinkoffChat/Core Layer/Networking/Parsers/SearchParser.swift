//
//  SearchParser.swift
//  TinkoffChat
//
//  Created by comandante on 5/10/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

struct Response: Codable {
  let hits: [Picture]
}



class SearchImagesParser: IParser {
  typealias Model = [Picture]
  
  func parse(data: Data) -> Model? {
    do {
      return try JSONDecoder().decode(Response.self, from: data).hits
    } catch {
      print("Error trying to convert data to JSON SearchParser")
      return nil
    }
  }
}
