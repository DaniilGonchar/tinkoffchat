//
//  Conversation.swift
//  TinkoffChat
//
//  Created by comandante on 4/1/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
  @nonobjc class func withId(conversationId: String) -> Conversation? {
    guard let fetchRequest: NSFetchRequest<Conversation> = CoreDataService.shared.fetchRequest(.conversationWithId, dictionary: ["conversationId": conversationId]) else {
      return nil
    }
    
    let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
    let dateSortDescriptor = NSSortDescriptor(key: "lastMessage.date", ascending: false)
    let nameSortDescriptor = NSSortDescriptor(key: "interlocutor.name", ascending: true)
    fetchRequest.sortDescriptors = [onlineSortDescriptor, dateSortDescriptor, nameSortDescriptor]
    
    return CoreDataService.shared.fetch(fetchRequest)?.first
  }
}

