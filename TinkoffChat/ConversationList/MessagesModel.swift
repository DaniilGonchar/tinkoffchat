//
//  MessagesModel.swift
//  TinkoffChat
//
//  Created by comandante on 3/21/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

struct MessageModel {
  var name: String?
  var message: String?
  var date: Date?
  var online: Bool
  var hasUnreadMessages: Bool
  
  
  init(name: String, message: String , date: Date, online: Bool, hasUnreadMessages: Bool) {
    self.name = name
    self.message = message
    self.date = date
    self.online = online
    self.hasUnreadMessages = hasUnreadMessages
  }
  
  // init without message
  init(name: String, date: Date, online: Bool, hasUnreadMessages: Bool) {
    self.name = name
    self.date = date
    self.online = online
    self.hasUnreadMessages = hasUnreadMessages
  }
}
