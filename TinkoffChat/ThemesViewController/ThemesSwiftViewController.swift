//
//  ThemesSwiftViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/22/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation


class ThemesSwiftViewController: UIViewController {
  
  typealias GetTheme = (ThemesSwift.Theme) -> ()
  
  var closure: GetTheme?
  
  var themes = ThemesSwift(theme1: ThemesSwift.Theme.init(barColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), theme2: ThemesSwift.Theme.init(barColor: #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)), theme3: ThemesSwift.Theme.init(barColor: #colorLiteral(red: 0.7725490196, green: 0.7019607843, blue: 0.3450980392, alpha: 1)))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let color = UserDefaults.standard.colorForKey(key: "Theme") {
      view.backgroundColor = color
    }
    
  }
  
  @IBAction func changeThemeAction(_ sender: UIButton) {
    
    if let titleOfButton = sender.titleLabel?.text {
      
      switch titleOfButton {
      case "Light":
        let theme = themes.theme1
        view.backgroundColor = theme.barColor
        closure?(theme)
      case "Dark":
        let theme = themes.theme2
        view.backgroundColor = theme.barColor
        closure?(theme)
      case "Champagne":
        let theme = themes.theme3
        view.backgroundColor = theme.barColor
        closure?(theme)
      default:
        print(#function, ": Exception caught")
      }
    }
    
  }
  
  @IBAction func dismissAction(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
}
