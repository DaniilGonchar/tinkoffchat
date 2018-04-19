//
//  FRCManager.swift
//  TinkoffChat
//
//  Created by comandante on 4/17/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation
import CoreData

class FRCManager: NSObject, NSFetchedResultsControllerDelegate {
  
  var delegate: ConversationDelegate?
  
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange sectionInfo: NSFetchedResultsSectionInfo,
                  atSectionIndex sectionIndex: Int,
                  for type: NSFetchedResultsChangeType) {
    DispatchQueue.main.async {
      switch type {
      case .insert:
        self.delegate?.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
      case .delete:
        self.delegate?.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
      case .update:
        self.delegate?.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
      case .move:
        self.delegate?.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        self.delegate?.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
      }
    }
  }
  
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    DispatchQueue.main.async {
      switch type {
      case .insert:
        if let newIndexPath = newIndexPath {
          self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
        }
      case .delete:
        if let indexPath = indexPath {
          self.delegate?.deleteRows(at: [indexPath], with: .automatic)
        }
      case .update:
        if let indexPath = indexPath {
          self.delegate?.reloadRows(at: [indexPath], with: .automatic)
        }
      case .move:
        if let indexPath = indexPath {
          self.delegate?.deleteRows(at: [indexPath], with: .automatic)
        }
        
        if let newIndexPath = newIndexPath {
          self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
        }
      }
    }
  }
  
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    DispatchQueue.main.async {
      self.delegate?.beginUpdates()
    }
  }
  
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    DispatchQueue.main.async {
      self.delegate?.endUpdates()
    }
  }
  
}


