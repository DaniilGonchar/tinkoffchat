//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by comandante on 3/27/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

protocol DataManagerProtocol {
  func saveProfile(profile: Profile, completion: @escaping (_ success: Bool) -> ())
  func loadProfile(completion: @escaping (_ profile: Profile?) -> ())
}

