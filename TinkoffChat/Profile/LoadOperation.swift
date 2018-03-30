//
//  LoadOperation.swift
//  TinkoffChat
//
//  Created by comandante on 3/27/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

class LoadProfileOperation: Operation {
  
  private let profileHandler: ProfileHandler
  var profile: Profile?
  
  
  init(profileHandler: ProfileHandler) {
    self.profileHandler = profileHandler
    super.init()
  }
  
  
  override func main() {
    if self.isCancelled { return }
    self.profile = self.profileHandler.loadData()
  }
}
