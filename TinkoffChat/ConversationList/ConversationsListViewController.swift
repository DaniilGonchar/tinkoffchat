//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit


class ConversationsListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var nameStringPressed: String?
  var messageModels : [[MessageModel]] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    tableView.dataSource = self
    tableView.delegate = self
    
    // creating some messages for testing purposes as data source for tableview cells
    //online category
    let someOldDate = Date(timeIntervalSinceReferenceDate: 542412351)
    let anotherOldDate = Date(timeIntervalSinceReferenceDate: 542325951)
    
    messageModels = [ [MessageModel]() , [MessageModel]() ]
    
    messageModels[0] = [ MessageModel(name: "Jack Douglas", message: "hey how is it going?", date: Date(), online: true, hasUnreadMessages: true) ,
                         MessageModel(name: "Sam Smith", message: "got it.", date: Date(), online: true, hasUnreadMessages: false) ,
                         MessageModel(name: "Sonia Aldred", message: "txt(debug:online,no unread)", date: Date(), online: true, hasUnreadMessages: false) ,
                         MessageModel(name: "Tyreece Barrow", message: "txt(debug:online,has unread)", date: Date(), online: true, hasUnreadMessages: true) ,
                         MessageModel(name: "Zeshan Devlin",  message: "ut labore et dolore magna ", date: someOldDate, online: true, hasUnreadMessages: false) ,
                         MessageModel(name: "Rea Sharma", message: "ut labore et dolore magna ", date: anotherOldDate, online: true, hasUnreadMessages: false) ,
                         MessageModel(name: "August Ventura Long Long Name", message: "quis nostrud exercitation ", date: Date(), online: true, hasUnreadMessages: false) ,
                         MessageModel(name: "Lea Ratliff", message: "in reprehenderit in voluptate ", date: Date(), online: true, hasUnreadMessages: false) ,
                         MessageModel(name: "Willis Duggan",  date: Date(), online: true, hasUnreadMessages: false) ,
                         MessageModel(name: "Darlene Knowles", date: Date(), online: true, hasUnreadMessages: false) ]
    
    // history category
    messageModels[1] = [ MessageModel(name: "Mary Black", message: "i have seen it!", date: Date(), online: false, hasUnreadMessages: true) ,
                         MessageModel(name: "Jay Baldwin", message: "man it looks gorgeous", date: Date(), online: false, hasUnreadMessages: false) ,
                         MessageModel(name: "Kim Mack Really long name thing", message: "another offline msg", date: anotherOldDate, online: false, hasUnreadMessages: false) ,
                         MessageModel(name: "John Lee", message:"txt(debug:offline,no unread)", date: Date(), online: false, hasUnreadMessages: false),
                         MessageModel(name: "Tabatha Haworth Name Is so Long it wont fit", message: "txt(debug:ofline,has unread)", date: Date(), online: false, hasUnreadMessages: true) ,
                         MessageModel(name: "Jonas Walsh", message: "delectus legendos est te, ne habeo", date: someOldDate, online: false, hasUnreadMessages: false) ,
                         MessageModel(name: "Kieron Wilkerson", message: "Quot tollit atomorum ea sed", date: Date(), online: false, hasUnreadMessages: false) ,
                         MessageModel(name: "Abdul Barclay", message: "et dico iracundia vix", date: Date(), online: false, hasUnreadMessages: true) ,
                         MessageModel(name: "Kelan Morrison", message: "Sale primis quo no", date: Date(), online: false, hasUnreadMessages: true) ,
                         MessageModel(name: "Rehaan Larson", message: "eam cu persecuti intellegebat", date: Date(), online: false, hasUnreadMessages: false) ]
    
    setupNavigationBarItems()
    
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
      let chatViewController = segue.destination as! ConversationViewController
      
      chatViewController.recievedNameString = nameStringPressed!
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
    // row was selected
    self.tableView.deselectRow(at: indexPath, animated: true)
    
    nameStringPressed = messageModels[indexPath.section][indexPath.row].name
    
    self.performSegue(withIdentifier: "showChatSegue" , sender: self)
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
}


// MARK: - UITableViewDataSource
extension ConversationsListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return messageModels.count
  }
  
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if (section == 0) {
      return "Online"
    } else {
      return "History"
    }
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0) {
      // "online" section
      return messageModels[0].count
    } else {
      // "offline" section
      return messageModels[1].count
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let conversationListCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ConversationCell
    
    let temporaryTestMessage: MessageModel
    if (indexPath.section == 0 ) {
      temporaryTestMessage = messageModels[0][indexPath.row]
    } else {
      temporaryTestMessage = messageModels[1][indexPath.row]
    }
    
    conversationListCell.message = temporaryTestMessage.message
    conversationListCell.date = temporaryTestMessage.date
    conversationListCell.name = temporaryTestMessage.name
    conversationListCell.hasUnreadMessages = temporaryTestMessage.hasUnreadMessages
    conversationListCell.online = temporaryTestMessage.online
    
    return conversationListCell
  }
  
}


// MARK: - ThemesViewControllerDelegate
extension ConversationsListViewController: ThemesViewControllerDelegate {
  func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
    logThemeChanging(selectedTheme: selectedTheme)
  }
}












