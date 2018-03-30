//
//  SaveOperation.swift
//  TinkoffChat
//
//  Created by comandante on 3/27/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

class SaveProfileOperation: Operation {
  
  var saveSucceeded: Bool = true
  private let profileHandler: ProfileHandler
  private let profile: Profile
  
  
  init(profileHandler: ProfileHandler, profile: Profile) {
    self.profileHandler = profileHandler
    self.profile = profile
    super.init()
  }
  
  
  override func main() {
    if self.isCancelled { return }
    self.saveSucceeded = self.profileHandler.saveData(profile: self.profile)
  }
  
}


