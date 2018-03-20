//
//  MessageCellConfiguration.swift
//  TinkoffChat
//
//  Created by comandante on 3/21/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation


protocol MessageCellConfiguration {
  var messageText: String? {get set}
  var isIncoming: Bool {get set}
  }
