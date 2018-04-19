//
//  AllowControlsDelegate.swift
//  TinkoffChat
//
//  Created by comandante on 4/17/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

protocol AllowControlsDelegate {
  var conversation: Conversation! {get set}
  
  func turnControlsOn()
  func turnControlsOff()
}
