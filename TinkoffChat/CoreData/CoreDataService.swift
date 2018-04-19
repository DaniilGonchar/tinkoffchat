//
//  CoreDataService.swift
//  TinkoffChat
//
//  Created by comandante on 4/17/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
  private init() {}
  
  var coreDataStack = CoreDataStack()
  static let shared = CoreDataService()
  
  enum EntityType: String {
    case user = "User"
    case message = "Message"
    case conversation = "Conversation"
  }
  
  enum FetchRequestKind: String {
    case userWithId = "UserWithId"
    case usersOnline = "UsersOnline"
    case conversationWithId = "ConversationWithId"
    case messagesInConversation = "MessagesInConversation"
  }
  
  enum SortDescriptorKind: String {
    case userId = "userId"
    case messageId = "messageId"
    case conversationId = "conversationId"
  }
  
  
  func add<T>(_ entity: EntityType) -> T where T: NSManagedObject {
    return NSEntityDescription.insertNewObject(forEntityName: entity.rawValue, into: coreDataStack.saveContext) as! T
  }
  
  
  func delete<T>(_ element: T) where T: NSManagedObject {
    coreDataStack.saveContext.delete(element)
  }
  
  
  func fetch<T>(_ request: NSFetchRequest<T>) -> [T]? where T: NSManagedObject {
    return try? coreDataStack.saveContext.fetch(request)
  }
  
  
  func getAll<T>(_ entity: EntityType) -> NSFetchRequest<T> where T: NSManagedObject {
    return NSFetchRequest<T>(entityName: entity.rawValue)
  }
  
  
  func save() {
    coreDataStack.performSave(context: coreDataStack.saveContext) { error in
      if let error = error {
        print(error)
      }
    }
  }
  
  
  // MARK: - NSFetchedResultsController
  func setupFRC<T>(_ fetchRequest: NSFetchRequest<T>, frcManager: FRCManager, sectionNameKeyPath: String? = nil) -> NSFetchedResultsController<T> where T: NSManagedObject {
    let fetchedResultsController = NSFetchedResultsController<T>(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.saveContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
    fetchedResultsController.delegate = frcManager
    
    return fetchedResultsController
  }
  
  
  func fetchData<T>(_ fetchedResultController: NSFetchedResultsController<T>) where T: NSManagedObject {
    do {
      try fetchedResultController.performFetch()
    } catch {
      print("Error performing fetch")
    }
  }
  
  
  // MARK: - NSFetchRequest
  func fetchRequest<T>(_ fetchRequest: FetchRequestKind, dictionary: [String: Any]? = nil) -> NSFetchRequest<T>? where T: NSManagedObject {
    let request: NSFetchRequest<T>?
    
    if dictionary == nil {
      request = coreDataStack.managedObjectModel.fetchRequestTemplate(forName: fetchRequest.rawValue) as? NSFetchRequest<T>
    } else {
      request = coreDataStack.managedObjectModel.fetchRequestFromTemplate(withName: fetchRequest.rawValue, substitutionVariables: dictionary!) as? NSFetchRequest<T>
    }
    
    guard request != nil else {
      assert(false, "No template with name \(fetchRequest.rawValue)")
      return nil
    }
    
    return request
  }
  
}
