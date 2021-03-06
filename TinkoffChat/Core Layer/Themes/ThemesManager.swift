//
//  ThemesManager.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

protocol IThemesManager {
  func apply(_ theme: UIColor, save: Bool)
  func loadAndApply()
}

class ThemesManager: IThemesManager {
  
  func apply(_ theme: UIColor, save: Bool) {
    DispatchQueue.global(qos: .utility).async {
      if save {
        UserDefaults.standard.setColor(color: theme, forKey: "Theme")
      }
      
      DispatchQueue.main.async {
        UINavigationBar.appearance().backgroundColor = theme
        UINavigationBar.appearance().barTintColor = theme
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
      
        let windows = UIApplication.shared.windows as [UIWindow]
        for window in windows {
          let subviews = window.subviews as [UIView]
          for vw in subviews {
            vw.removeFromSuperview()
            window.addSubview(vw)
          }
        }
      }
    }
  }
  
  
  func loadAndApply() {
    DispatchQueue.global(qos: .userInteractive).async {
      if let theme = UserDefaults.standard.colorForKey(key: "Theme") {
        DispatchQueue.main.async {
          self.apply(theme, save: false)
        }
      }
    }
  }
  
}
