//
//  ThemesModel.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

typealias ColorAlias = ((ThemesViewController, UIColor?) -> ())



protocol IThemesModel: class {
  var theme1: UIColor { get }
  var theme2: UIColor { get }
  var theme3: UIColor { get }
  
  typealias ColorAlias = ((ThemesViewController, UIColor?) -> ())
  var closure: ColorAlias { get }
}



class ThemesModel: IThemesModel {
  
  var theme1, theme2, theme3: UIColor
  var closure: ColorAlias
  
  init(theme1: UIColor, theme2: UIColor, theme3: UIColor, closure: @escaping ColorAlias) {
    self.theme1 = theme1
    self.theme2 = theme2
    self.theme3 = theme3
    self.closure = closure
  }
  
}
