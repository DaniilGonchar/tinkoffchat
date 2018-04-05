//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit


class ConversationViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      // workaround for displaying messages bottom -> top
      tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
  }
  @IBOutlet weak var inputTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  
  
  // force is okay here
  var communicator: Communicator!
  var conversation: Conversation!
  
  var sendButtonLocked = false
  
  @IBAction func sendButtonPressed() {
    
    if (sendButtonLocked)
    {
      sendButton.shakeButton()
    }
    else {
      guard let text = inputTextField.text, !text.isEmpty else { return }
      
      communicator.sendMessage(string: text, to: conversation.id) { [weak self] success, error in
        if success {
          // clear textField for the new input
          self?.inputTextField.text = nil
          
          self?.conversation.date = Date()
          self?.conversation.message = text
          self?.conversation.messages.insert(ChatMessageModel(messageText: text, isIncoming: false), at: 0)
          
          self?.tableView.reloadData()
          
          NotificationCenter.default.post(name: Notification.Name("ConversationsListSortData"), object: nil)
        } else {
          let alertController = UIAlertController(title: "Error", message: "message was not sent", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Done", style: .destructive))
          self?.present(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.white
    self.navigationItem.title = conversation.name
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
    tableView.dataSource = self
    tableView.delegate = self
    
    inputTextField.delegate = self
    inputTextField.layer.borderWidth = 1
    inputTextField.layer.cornerRadius = 5
    inputTextField.placeholder = "Enter mesage"
    inputTextField.autocorrectionType = UITextAutocorrectionType.no
    
    sendButton.layer.borderWidth = 1
    sendButton.layer.cornerRadius = 5
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    // adding observers
    NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ConversationReloadData"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(lockTheSendButton), name: Notification.Name("ConversationTurnSendOff"), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    
    NotificationCenter.default.removeObserver(self, name: Notification.Name("ConversationReloadData"), object: nil)
    NotificationCenter.default.removeObserver(self, name: Notification.Name("ConversationTurnSendOff"), object: nil)
    
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    conversation.hasUnreadMessages = false
    
    view.gestureRecognizers?.removeAll()
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // hides keyboard when tapped outside keyboard
    self.view.endEditing(true)
  }
  
  
  @objc private func reloadData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  
  @objc private func lockTheSendButton() {
    DispatchQueue.main.async {
      self.sendButtonLocked = true
    }
  }
  
  
  @objc func keyboardWillShow(_ notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardHeight = keyboardFrame.cgRectValue.height
      
      self.view.frame.origin.y -= keyboardHeight
    }
  }
  
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
   
    if self.view.frame.origin.y >= 0 {
      return
    }
    
    if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardHeight = keyboardFrame.cgRectValue.height
      self.view.frame.origin.y += keyboardHeight
    
    }
  
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
    return conversation.messages.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let message = conversation.messages[indexPath.row]
    var identifier: String
    if (message.isIncoming){
      identifier = "incomingCell"
    } else {
      identifier = "outgoingCell"
    }
    
    var myCell: MessageCell
    
    if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell {
      myCell = cell
    } else {
      myCell = MessageCell(style: .default, reuseIdentifier: identifier)
    }
    
    myCell.selectionStyle = UITableViewCellSelectionStyle.none
    myCell.messageTextLabel.lineBreakMode = .byWordWrapping
    myCell.messageTextLabel.numberOfLines = 0;
    
    myCell.messageText = message.messageText
    myCell.isIncoming = message.isIncoming
    
    // workaround for displaying messages bottom -> top
    myCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
    
    return myCell
  }
  
}



// MARK: - UITextFieldDelegate
extension ConversationViewController: UITextFieldDelegate {
  // hide the keyboard after pressing return key
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true;
  }
  
  
  // limiting input length for textfield
  // we might need this in the future to fit bluetooth requirements
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.count + string.count - range.length
    return newLength <= 300
  }
  
}
