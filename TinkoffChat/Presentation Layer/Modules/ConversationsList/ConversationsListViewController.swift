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
  
  private var emitter: Emitter!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var model: IConversationListModel
  private let presentationAssembly: IPresentationAssembly
  
  
  init(model: IConversationListModel, presentationAssembly: IPresentationAssembly) {
    self.model = model
    self.presentationAssembly = presentationAssembly
    
    super.init(nibName: nil, bundle: nil)
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    model.restoreThemeSettings()
    setupTableView()
    
    model.dataSourcer = ConversationsDataSource(delegate: tableView, fetchRequest: model.frcService.allConversations()!, context: model.frcService.saveContext)
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    // adding observers
    setupNavigationBarItems()
    
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
 
  }
  
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ConversationCell", bundle: nil),
                       forCellReuseIdentifier: "ConversationCell")
  }
  
  
  private func setupNavigationBarItems(){
    navigationItem.title = "Tinkoff Chat"
    
    let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "user-512"), style: .plain , target: self, action: #selector(self.profileButtonFunc) )
    profileButton.tintColor = UIColor.gray
    navigationItem.rightBarButtonItem = profileButton
    
    let themesButton = UIBarButtonItem(title: "Темы", style: .plain, target: self, action: #selector(self.themesButtonFunc) )
    
    navigationItem.leftBarButtonItem = themesButton
    
  }
  
  
  @objc func profileButtonFunc(){
    let controller = presentationAssembly.profileViewController()
    let navigationController = UINavigationController()
    navigationController.viewControllers = [controller]
    
    emitter = Emitter(view: navigationController.view)
    
    present(navigationController, animated: true)
  }
  
  
  @objc func themesButtonFunc(){
    let controller = presentationAssembly.themesViewController() { [weak self] (controller: ThemesViewController, selectedTheme: UIColor?) in
      guard let theme = selectedTheme else { return }
      controller.view.backgroundColor = theme
      self?.model.saveSettings(for: theme)
    }
    
    let navigationController = UINavigationController()
    navigationController.viewControllers = [controller]
    
    emitter = Emitter(view: navigationController.view)
    
    present(navigationController, animated: true)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}



// MARK: - UITableViewDelegate
extension ConversationsListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let conversation = model.dataSourcer?.fetchedResultsController.object(at: indexPath) else { return }
    let controller = presentationAssembly.conversationViewController(model: ConversationModel(communicationService: model.communicationService, frcService: model.frcService, conversation: conversation))
    
    controller.navigationItem.title = conversation.interlocutor?.name
    navigationController?.pushViewController(controller, animated: true)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
}



// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sectionsCount = model.dataSourcer?.fetchedResultsController.sections?.count else {
      return 0
    }
    
    return sectionsCount
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = model.dataSourcer?.fetchedResultsController.sections else {
      return 0
    }
    
    return sections[section].numberOfObjects
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "ConversationCell"
    var myCell: ConversationCell
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ConversationCell {
      myCell = cell
    } else {
      myCell = ConversationCell(style: .default, reuseIdentifier: identifier)
    }
    
    if let conversation = model.dataSourcer?.fetchedResultsController.object(at: indexPath) {
      if let interlocutor = conversation.interlocutor {
        myCell.name = interlocutor.name
      }
      
      myCell.online = conversation.isOnline
      myCell.date = conversation.lastMessage?.date ?? nil
      myCell.lastMessageText = conversation.lastMessage?.messageText ?? nil
      myCell.hasUnreadMessages = conversation.hasUnreadMessages
    }
    
    return myCell
  }
  
}



