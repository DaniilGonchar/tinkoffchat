//
//  CommunicatorDelegate.swift
//  TinkoffChat
//
//  Created by comandante on 4/3/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

protocol CommunicatorDelegate : class {
  // discovery
  func didFoundUser(userID: String, userName: String?)
  func didLostUser(userID: String)
  
  // errors
  func failedToStartBrowsingForUsers(error: Error)
  func failedToStartAdvertising(error: Error)
  
  // message
  func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

