//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by comandante on 4/5/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {
  
  var conversations = [[Conversation]]()
  
  
  init() {
    // two sections
    conversations.append([Conversation]())
    conversations.append([Conversation]())
    
    // adding observer
    NotificationCenter.default.addObserver(self, selector: #selector(sortConversationsData), name: Notification.Name("ConversationsListSortData"), object: nil)
  }
  
  
  @objc private func sortConversationsData() {
    conversations[0].sort(by: Conversation.sortByDate)
  }
  
  
  deinit {
    // removing observer
    NotificationCenter.default.removeObserver(self, name: Notification.Name("ConversationsListSortData"), object: nil)
  }
  
  
  func didFoundUser(userID: String, userName: String?) {
    guard conversations[0].index(where: { (item) -> Bool in item.id == userID }) == nil else {
      return
    }
    
    conversations[0].append(Conversation(id: userID,
                                         name: userName,
                                         message: nil,
                                         messages: [ChatMessageModel](),
                                         date: nil,
                                         online: true,
                                         hasUnreadMessages: false))
    conversations[0].sort(by: Conversation.sortByDate)
    
    NotificationCenter.default.post(name: Notification.Name("ConversationsListReloadData"), object: nil)
  }
  
  
  func didLostUser(userID: String) {
    if let index = conversations[0].index(where: { (item) -> Bool in item.id == userID }) {
      conversations[0].remove(at: index)
      
      NotificationCenter.default.post(name: Notification.Name("ConversationsListReloadData"), object: nil)
      
      NotificationCenter.default.post(name: Notification.Name("ConversationTurnSendOff"), object: nil)
    }
  }
  
  
  func didReceiveMessage(text: String, fromUser: String, toUser: String) {
    if let index = conversations[0].index(where: { (item) -> Bool in item.id == fromUser }) {
      
      conversations[0][index].messages.insert(ChatMessageModel(messageText: text, isIncoming: true), at: 0)
      
      conversations[0][index].date = Date()
      conversations[0][index].hasUnreadMessages = true
      conversations[0][index].message = conversations[0][index].messages.first?.messageText
      
      conversations[0].sort(by: Conversation.sortByDate)
      
      
      NotificationCenter.default.post(name: Notification.Name("ConversationsListReloadData"), object: nil)
      NotificationCenter.default.post(name: Notification.Name("ConversationReloadData"), object: nil)
    }
  }
  
  
  func failedToStartBrowsingForUsers(error: Error) {
    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
    alertController.present(alertController, animated: true, completion: nil)
  }
  
  
  func failedToStartAdvertising(error: Error) {
    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Done", style: .cancel))
    alertController.present(alertController, animated: true, completion: nil)
  }
}
