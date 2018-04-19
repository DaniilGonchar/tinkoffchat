//
//  User.swift
//  TinkoffChat
//
//  Created by comandante on 4/17/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import CoreData

extension User {
  @nonobjc class func withId(userId: String) -> User? {
    guard let fetchRequest: NSFetchRequest<User> = CoreDataService.shared.fetchRequest(.userWithId, dictionary: ["userId": userId]) else {
      return nil
    }
    
    return CoreDataService.shared.fetch(fetchRequest)?.first
  }
}
