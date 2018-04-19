//
//  ConversationDelegate.swift
//  TinkoffChat
//
//  Created by comandante on 4/17/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import Foundation

protocol ConversationDelegate {
  
  func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
  func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
  func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation)
  
  func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
  func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
  func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)
  
  func beginUpdates()
  func endUpdates()
}
