//
//  DataManagerProtocol.swift
//  TinkoffChat
//
//  Created by comandante on 3/27/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

protocol DataManagerProtocol {
  func saveProfile(_ profile: Profile, completion: @escaping (Error?) -> ())
  func loadProfile(completion: @escaping (Profile?, Error?) -> ())
}

