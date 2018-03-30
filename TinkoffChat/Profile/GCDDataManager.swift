//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by comandante on 3/27/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

class GCDDataManager: DataManagerProtocol {
  
  let profileHandler: ProfileHandler = ProfileHandler()
  
  
  func saveProfile(profile: Profile, completion: @escaping (_ success: Bool) -> ()) {
    DispatchQueue.global(qos: .userInitiated).async {
      let saveSucceeded = self.profileHandler.saveData(profile: profile)
      
      DispatchQueue.main.async {
        completion(saveSucceeded)
      }
    }
  }
  
  
  func loadProfile(completion: @escaping (_ profile: Profile?) -> ()) {
    DispatchQueue.global(qos: .userInitiated).async {
      let retrievedProfile = self.profileHandler.loadData()
      
      DispatchQueue.main.async {
        completion(retrievedProfile)
      }
    }
  }
  
}
      
