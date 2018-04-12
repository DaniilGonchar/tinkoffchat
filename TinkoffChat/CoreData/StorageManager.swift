//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by comandante on 4/11/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//


//Необходимо в текущем проекте:
//1. Создать CoreDataStack объект, который бы отражал стек из презентации/туториала.
//2. Создать менеджер StorageManager, который бы отвечал за инициализацию стека и работу с бд (бизнес-логику).
//3. Реализовать сохранение и чтение данных профиля из CoreData, через менеджер.


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



// MARK: - CoreData
extension ProfileEntity {
  class func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<ProfileEntity>? {
    let requestTemplateName = "ProfileFetchRequest"
    guard let fetchRequest = model.fetchRequestTemplate(forName: requestTemplateName) as? NSFetchRequest<ProfileEntity> else {
      assert(false, "Error: no template with name \(requestTemplateName)")
      return nil
    }
    return fetchRequest
  }
  
  
  class func insert(in context: NSManagedObjectContext) -> ProfileEntity? {
    return NSEntityDescription.insertNewObject(forEntityName: "ProfileEntity", into: context) as? ProfileEntity
  }
  
  
  class func findOrInsert(in context: NSManagedObjectContext) -> ProfileEntity? {
    guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
      print("Model is not available in context")
      assert(false)
      return nil
    }
    
    var profile: ProfileEntity?
    guard let fetchRequest = fetchRequest(model: model) else {
      return nil
    }
    
    do {
      let results = try context.fetch(fetchRequest)
      assert(results.count < 2, "Multiple profiles found")
      if let foundProfile = results.first {
        profile = foundProfile
      }
    }
    catch {
      print("Failed to fetch profile \(error)")
    }
    
    if profile == nil {
      profile = ProfileEntity.insert(in: context)
    }
    
    return profile
  }
  
}


