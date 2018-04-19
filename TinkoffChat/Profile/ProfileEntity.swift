//
//  ProfileEntity.swift
//  TinkoffChat
//
//  Created by comandante on 4/19/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import CoreData

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
