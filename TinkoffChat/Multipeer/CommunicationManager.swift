//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by comandante on 4/5/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {
  
  func didFoundUser(userID: String, userName: String?) {
    
    let conversation = Conversation.withId(conversationId: userID)
    guard conversation == nil else {
      conversation?.isOnline = true
      CoreDataService.shared.save()
      return
    }
    
    let user: User = CoreDataService.shared.add(.user)
    user.userId = userID
    user.name = userName
    
    user.isOnline = true
    
    let chat: Conversation = CoreDataService.shared.add(.conversation)
    
    chat.conversationId = userID
    chat.interlocutor = user
    
    chat.hasUnreadMessages = false
    chat.profileEntity = nil
    chat.lastMessage = nil
    chat.isOnline = true
    
    user.addToConversations(chat)
    
    CoreDataService.shared.save()
    
  }
  
  
  func didLostUser(userID: String) {
  
    guard let user = User.withId(userId: userID), let conversation = Conversation.withId(conversationId: userID) else {
      return
    }
    
    if conversation.lastMessage != nil {
      conversation.isOnline = false
    } else {
      CoreDataService.shared.delete(conversation)
      CoreDataService.shared.delete(user)
    }
    
    CoreDataService.shared.save()
    
  }
  
  
  func didReceiveMessage(text: String, fromUser: String, toUser: String) {
    
    guard let conversation = Conversation.withId(conversationId: fromUser) else {
      return
    }
    
    let message: Message = CoreDataService.shared.add(.message)
    message.messageId = Message.generateMessageId()
    message.isIncoming = true
    message.messageText = text
    message.date = Date()
    message.conversation = conversation
    message.lastMessageInConversation = conversation
    
    conversation.hasUnreadMessages = true
    
    CoreDataService.shared.save()
    
  }
  
  
  func failedToStartBrowsingForUsers(error: Error) {
    print("Failed To Start Browsing For Users:",error.localizedDescription)
    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
    alertController.present(alertController, animated: true, completion: nil)
  }
  
  
  func failedToStartAdvertising(error: Error) {
    print("Failed To Start Advertising:",error.localizedDescription)
    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
    alertController.present(alertController, animated: true, completion: nil)
  }
  
}
