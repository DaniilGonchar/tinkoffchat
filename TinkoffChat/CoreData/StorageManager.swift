//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by comandante on 4/11/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import CoreData

class StorageManager: DataManagerProtocol {
  private let coreDataStack = CoreDataStack()
  
  
  func saveProfile(_ profile: Profile, completion: @escaping (Error?) -> ()) {
    let saveContext = coreDataStack.saveContext
    
    saveContext.perform {
      let profileEntity = ProfileEntity.findOrInsert(in: saveContext)
      profileEntity?.name = profile.name
      profileEntity?.bio = profile.bio
      
      if let picture = profile.image {
        profileEntity?.image = UIImageJPEGRepresentation(picture, 1.0)
      }
      
      self.coreDataStack.performSave(context: saveContext) { error in
        DispatchQueue.main.async {
          completion(error)
        }
      }
    }
  }
  
  
  func loadProfile(completion: @escaping (Profile?, Error?) -> ()) {
    let mainContext = coreDataStack.mainContext
    
    mainContext.perform {
      guard let profileEntity = ProfileEntity.findOrInsert(in: mainContext) else {
        completion(nil, nil)
        return
      }
      
      let profile = Profile()
      profile.name = profileEntity.name
      profile.bio = profileEntity.bio
      if let picture = profileEntity.image {
        profile.image = UIImage(data: picture)
      }
      
      completion(profile, nil)
    }
  }
  
}






