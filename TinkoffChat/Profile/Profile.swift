//
//  Profile.swift
//  TinkoffChat
//
//  Created by comandante on 3/27/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//


class Profile {
  
  var name: String?
  var bio: String?
  var image: UIImage?
  
  init() {}
  
  init(name: String?, bio: String?, image: UIImage?) {
    self.name = name
    self.bio = bio
    self.image = image
  }
  
}


