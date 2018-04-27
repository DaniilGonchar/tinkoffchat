//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by comandante on 4/23/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationModel: class {
  
  var communicationService: ICommunicatorDelegate { get set }
  
  var conversation: Conversation { get set }
  
}

class ConversationModel: IConversationModel {
  let frcService: IFRCService
  
  var communicationService: ICommunicatorDelegate
  
  var conversation: Conversation
  
  var dataSourcer: MessagesDataSource?
  
  
  func makeRead() {
    guard let id = conversation.conversationId else { return }
    communicationService.didConversationRead(id: id)
  }
  
  
  init(communicationService: ICommunicatorDelegate,
       frcService: IFRCService,
       conversation: Conversation) {
    self.communicationService = communicationService
    self.frcService = frcService
    self.conversation = conversation
  }
  
}
