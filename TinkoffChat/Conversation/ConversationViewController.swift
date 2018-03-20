//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit


class ConversationViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var recievedNameString = String()
  var messageModels = [ChatMessageModel]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = recievedNameString
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
    
  
    // creating 6 test messages
    messageModels.append(ChatMessageModel(messageText: "I", isIncoming: true))
    messageModels.append(ChatMessageModel(messageText: "umm", isIncoming: true))
    messageModels.append(ChatMessageModel(messageText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, qiallum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", isIncoming: false))
    messageModels.append(ChatMessageModel(messageText: "Dolor sit amet, conset at teu?", isIncoming: true))
    messageModels.append(ChatMessageModel(messageText: "Ut aliq ex ea modo consequat. ", isIncoming: false))
    messageModels.append(ChatMessageModel(messageText: "w", isIncoming: true))
  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}


// MARK: - UITableViewDelegate
extension ConversationViewController: UITableViewDelegate {
  
}


// MARK: - UITableViewDataSource
extension ConversationViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messageModels.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
    if (messageModels[indexPath.row].isIncoming) {
      //incoming message
      let myCell = tableView.dequeueReusableCell(withIdentifier: "incomingCell") as! MessageCell
      
      myCell.selectionStyle = UITableViewCellSelectionStyle.none
      myCell.messageTextLabel.lineBreakMode = .byWordWrapping
      myCell.messageTextLabel.numberOfLines = 0;
      
      myCell.messageText = messageModels[indexPath.row].messageText
      myCell.isIncoming = messageModels[indexPath.row].isIncoming
    
      return myCell
    } else {
      //outgoing message
      let myCell = tableView.dequeueReusableCell(withIdentifier: "outgoingCell") as! MessageCell
    
      myCell.selectionStyle = UITableViewCellSelectionStyle.none
      myCell.messageTextLabel.lineBreakMode = .byWordWrapping
      myCell.messageTextLabel.numberOfLines = 0;
      
      myCell.messageText = messageModels[indexPath.row].messageText
      myCell.isIncoming = messageModels[indexPath.row].isIncoming
      
      return myCell
    }
  }
  
}
