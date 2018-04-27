//
//  ThemesService.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

protocol IThemesService: class {
  func save(_ theme: UIColor)
  func load()
}

class ThemesService: IThemesService {
  private let themesManager: IThemesManager
  
  
  init(themesManager: IThemesManager) {
    self.themesManager = themesManager
  }
  
  
  func save(_ theme: UIColor) {
    themesManager.apply(theme, save: true)
  }
  
  
  func load() {
    themesManager.loadAndApply()
  }
  
}
