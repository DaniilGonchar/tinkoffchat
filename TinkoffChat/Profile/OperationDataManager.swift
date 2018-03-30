//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by comandante on 3/27/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

import Foundation

class OperationDataManager: DataManagerProtocol {
  
  let profileHandler: ProfileHandler = ProfileHandler()
  
  
  func saveProfile(profile: Profile, completion: @escaping (Bool) -> ()) {
    
    let operationQueue = OperationQueue()
    let saveOperation = SaveProfileOperation(profileHandler: self.profileHandler, profile: profile)
    saveOperation.qualityOfService = .userInitiated
    
    saveOperation.completionBlock = {
      OperationQueue.main.addOperation {
        completion(saveOperation.saveSucceeded)
      }
    }
    
    operationQueue.addOperation(saveOperation)
  }
  
  func loadProfile(completion: @escaping (Profile?) -> ()) {
    
    let operationQueue = OperationQueue()
    let loadOperation = LoadProfileOperation(profileHandler: self.profileHandler)
    loadOperation.qualityOfService = .userInitiated
    
    loadOperation.completionBlock = {
      OperationQueue.main.addOperation {
        completion(loadOperation.profile)
      }
    }
    
    operationQueue.addOperation(loadOperation)
  }
}


