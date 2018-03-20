//
//  ChatMessageModel.swift
//  TinkoffChat
//
//  Created by comandante on 3/21/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation


struct ChatMessageModel {
  var messageText: String?
  var isIncoming: Bool
  
  
  init(messageText: String, isIncoming: Bool) {
    self.messageText = messageText
    self.isIncoming = isIncoming
  }
}
