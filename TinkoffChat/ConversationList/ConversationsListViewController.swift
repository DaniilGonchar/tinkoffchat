//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit
import CoreData


class ConversationsListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  private var communicator: Communicator = MultipeerCommunicator()
  private var communicationManager: CommunicatorDelegate = CommunicationManager()
  
  private var fetchedResultsController: NSFetchedResultsController<Conversation>!
  private var frcManager = FRCManager()
  private var controlsDelegate: AllowControlsDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    tableView.dataSource = self
    tableView.delegate = self
    communicator.delegate = communicationManager
    
    let fetchRequest: NSFetchRequest<Conversation> = CoreDataService.shared.getAll(.conversation)
    
    let onlineSortDescriptor = NSSortDescriptor(key: "isOnline", ascending: false)
    let dateSortDescriptor = NSSortDescriptor(key: "lastMessage.date", ascending: false)
    let nameSortDescriptor = NSSortDescriptor(key: "interlocutor.name", ascending: true)
    
    fetchRequest.sortDescriptors = [onlineSortDescriptor, dateSortDescriptor, nameSortDescriptor]
    
    frcManager.delegate = tableView
    
    fetchedResultsController = CoreDataService.shared.setupFRC(fetchRequest, frcManager: frcManager)
    CoreDataService.shared.fetchData(fetchedResultsController)
    
    fetchedResultsController?.fetchedObjects?.forEach({ $0.isOnline = false })
    
    setupNavigationBarItems()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    // adding observers
    NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ConversationsListReloadData"), object: nil)
    
    tableView.reloadData()  // this is needed due to lifecycle
    
  }
  
  
  @objc private func reloadData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    
    // removing observers
    NotificationCenter.default.removeObserver(self, name: Notification.Name("ConversationsListReloadData"), object: nil)
  }
  
  
  private func setupNavigationBarItems(){
    
    let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "user-512"), style: .plain , target: self, action: #selector(self.profileButtonFunc) )
    profileButton.tintColor = UIColor.gray
    navigationItem.rightBarButtonItem = profileButton
    
    let themesButton = UIBarButtonItem(title: "Themes", style: .plain, target: self, action: #selector(self.themesButtonFunc) )
    
    navigationItem.leftBarButtonItem = themesButton
    
  }
  
  
  @objc func profileButtonFunc(){
    self.performSegue(withIdentifier: "showProfileSegue", sender: self)
  }
  
  
  @objc func themesButtonFunc(){
    self.performSegue(withIdentifier: "presentThemesSegue", sender: self)
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if (segue.identifier == "showChatSegue") {
      if let chatViewController = segue.destination as? ConversationViewController {
        
        if let indexPath = tableView.indexPathForSelectedRow {
          controlsDelegate = chatViewController
          controlsDelegate?.conversation = fetchedResultsController?.object(at: indexPath)
          
          chatViewController.communicator = communicator
          chatViewController.navigationItem.title = controlsDelegate?.conversation.interlocutor?.name
        }
      }
      
    } else if (segue.identifier == "presentThemesSegue") {
      
      let navVC = segue.destination as! UINavigationController
      
      if let themesViewControllerObjc = navVC.topViewController as? ThemesViewController {
        themesViewControllerObjc.delegate = self
      } else if let themesViewControllerSwift = navVC.topViewController as? ThemesSwiftViewController {
        themesViewControllerSwift.closure = { logThemeChangingSwift }()
      }
    }
  }
  
  
  func logThemeChanging(selectedTheme: UIColor) {
    print(#function, selectedTheme)
    UINavigationBar.appearance().barTintColor = selectedTheme
    UserDefaults.standard.setColor(color: selectedTheme, forKey: "Theme")
  }
  
  
  func logThemeChangingSwift(selectedTheme: ThemesSwift.Theme) -> Void {
    print(#function, selectedTheme)
    UINavigationBar.appearance().barTintColor = selectedTheme.barColor
    UserDefaults.standard.setColor(color: selectedTheme.barColor, forKey: "Theme")
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}



// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "showChatSegue" , sender: self)
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
}



// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sectionsCount = fetchedResultsController?.sections?.count else {
      return 0
    }
    
    return sectionsCount
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController?.sections else {
      return 0
    }
    
    return sections[section].numberOfObjects
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var conversationCell: ConversationCell
    
    if let conversationListCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as? ConversationCell {
      // success
      conversationCell = conversationListCell
    } else {
      // if deque failed
      conversationCell = ConversationCell(style: .default, reuseIdentifier: "listCell")
    }
    
    
    
    if let retrievedConversation = fetchedResultsController?.object(at: indexPath) {
      if let interlocutor = retrievedConversation.interlocutor {
        conversationCell.name = interlocutor.name
      }
      
      conversationCell.online = retrievedConversation.isOnline
      conversationCell.date = retrievedConversation.lastMessage?.date ?? nil
      conversationCell.message = retrievedConversation.lastMessage?.messageText ?? nil
      conversationCell.hasUnreadMessages = retrievedConversation.hasUnreadMessages
      
      if retrievedConversation.isOnline && retrievedConversation == controlsDelegate?.conversation {
        controlsDelegate?.turnControlsOn()
      } else {
        controlsDelegate?.turnControlsOff()
      }
    }
    
    return conversationCell
  }
  
}



// MARK: - ThemesViewControllerDelegate
extension ConversationsListViewController: ThemesViewControllerDelegate {
  func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
    logThemeChanging(selectedTheme: selectedTheme)
  }
}



// MARK: - ConversationDelegate
extension UITableView: ConversationDelegate {
  // this stub fixes line: "frcManager.delegate = tableView"
}











