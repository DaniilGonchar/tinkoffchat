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
  
  var nameChanged: Bool = false
  var bioChanged: Bool = false
  var imageChanged: Bool = false
  
  init() {}
  
  init(name: String?, bio: String?, image: UIImage?) {
    self.name = name
    self.bio = bio
    self.image = image
  }
  
}



class ProfileHandler {
  
  private let nameFileName = "name.txt"
  private let bioFileName = "bio.txt"
  private let imageFileName = "userImage.png"
  
  let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  
  func saveData(profile: Profile) -> Bool {
    do {
      if profile.nameChanged, let unwrappedName = profile.name {
        try unwrappedName.write(to: filePath.appendingPathComponent(self.nameFileName), atomically: true, encoding: String.Encoding.utf8)
      }
      
      if profile.bioChanged, let unwrappedBio = profile.bio {
        try unwrappedBio.write(to: filePath.appendingPathComponent(self.bioFileName), atomically: true, encoding: String.Encoding.utf8)
      }
      
      if profile.imageChanged, let unwrappedImage = profile.image {
        let imageData = UIImagePNGRepresentation(unwrappedImage);
        try imageData?.write(to: filePath.appendingPathComponent(self.imageFileName), options: .atomic);
      }
      return true
    } catch {
      return false
    }
  }
  
 
  func loadData() -> Profile? {
    let profile: Profile = Profile()
    do {
      profile.name = try String(contentsOf: filePath.appendingPathComponent(self.nameFileName))
      profile.bio = try String(contentsOf: filePath.appendingPathComponent(self.bioFileName))
      profile.image = UIImage(contentsOfFile: filePath.appendingPathComponent(self.imageFileName).path)
      return profile
    } catch {
      return nil
    }
  }
  
}


