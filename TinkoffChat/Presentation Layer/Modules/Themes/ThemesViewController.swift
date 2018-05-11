//
//  ThemesSwiftViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/22/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

class ThemesViewController: UIViewController {
  
  private let model: IThemesModel
  
  
  init(model: IThemesModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupNavbar()
    
    DispatchQueue.global(qos: .userInteractive).async {
      if let theme = UserDefaults.standard.colorForKey(key: "Theme") {
        DispatchQueue.main.async {
          self.view.backgroundColor = theme
        }
      }
    }
    
  }
  
  @IBAction func changeThemeAction(_ sender: UIButton) {
    
    if let titleOfButton = sender.titleLabel?.text {
      
      switch titleOfButton {
      case "Light":
        model.closure(self, model.theme1)
      case "Dark":
        model.closure(self, model.theme2)
      case "Champagne":
        model.closure(self, model.theme3)
      default:
        print(#function, ": Exception caught")
      }
    }
    
  }
  
  @objc private func closeVC() {
    dismiss(animated: true)
  }
  
  private func setupNavbar() {
    navigationItem.title = "Темы"
    let leftItem = UIBarButtonItem(title: "Назад",
                                    style: .plain,
                                    target: self,
                                    action: #selector(closeVC))
    navigationItem.setLeftBarButton(leftItem, animated: true)
  }
  
}
