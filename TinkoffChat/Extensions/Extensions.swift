//
//  Extensions.swift
//  TinkoffChat
//
//  Created by comandante on 3/22/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//


import Foundation

extension UserDefaults {
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
    }
    set(colorData, forKey: key)
  }
  
  func colorForKey(key: String) -> UIColor? {
    var color: UIColor?
    if let colorData = data(forKey: key) {
      color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
    }
    return color
  }
  
}


extension UIButton {
  
  func shakeButton() {
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.07
    animation.repeatCount = 2
    animation.autoreverses = true
    animation.fromValue = NSValue(cgPoint: CGPoint.init(x: self.center.x - 5, y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint.init(x: self.center.x + 5, y: self.center.y))
    self.layer.add(animation, forKey: "position")
  }
  
}
