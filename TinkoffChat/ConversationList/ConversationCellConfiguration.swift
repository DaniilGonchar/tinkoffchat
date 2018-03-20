//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by comandante on 3/20/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration: class {
  var name: String? {get set}
  var message: String? {get set}
  var date: Date? {get set}
  var online: Bool {get set}
  var hasUnreadMessages: Bool {get set}
}
