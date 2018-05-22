//
//  Emitter.swift
//  TinkoffChat
//
//  Created by comandante on 5/20/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import UIKit

class Emitter {
  
  private weak var superView: UIView?
  private var emitter = CAEmitterLayer()
  
  private var longPressRecognizer = UILongPressGestureRecognizer()
  
  init(view: UIView) {
    superView = view
    longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(performLongPressAnimations))
    superView?.addGestureRecognizer(longPressRecognizer)
  }
  
  private func generateEmitterCells() {
    superView?.endEditing(true)
    
    emitter.emitterPosition = longPressRecognizer.location(in: superView)
    emitter.emitterShape = kCAEmitterLayerCircle
    emitter.emitterSize = CGSize(width: 30, height: 30)
    
    let cell = CAEmitterCell()
    
    cell.contents = UIImage(named: "TinkoffFlake")?.cgImage
    cell.birthRate = 8
    cell.lifetime = 2
    cell.velocity = CGFloat(55)
    cell.contentsScale = 10
    cell.velocityRange = 10
    cell.yAcceleration = -70.0
    cell.xAcceleration = -10
    cell.emissionRange = .pi / 6
    
    emitter.emitterCells = [cell]
    superView?.layer.addSublayer(emitter)
  }
  
  @objc private func performLongPressAnimations(_ sender: UILongPressGestureRecognizer) {
    switch longPressRecognizer.state {
    case .began:
      generateEmitterCells()
    case .ended:
      emitter.removeFromSuperlayer()
    case .changed:
      emitter.emitterPosition = sender.location(in: superView)
    default:
      break
    }
  }
  
}
