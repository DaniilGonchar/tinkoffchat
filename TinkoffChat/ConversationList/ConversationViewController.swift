//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit
import CoreData

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
  
  private var fetchedResultsController: NSFetchedResultsController<Message>!
  private var frcManager = FRCManager()
  
  var sendButtonLocked = false
  
  
  @IBAction func sendButtonPressed() {
    
    if (sendButtonLocked)
    {
      sendButton.shakeButton()
    }
    else {
      guard let text = inputTextField.text, let receiver = conversation.interlocutor?.userId, !text.isEmpty else {
        return
      }
      
      communicator.sendMessage(string: text, to: receiver) { [weak self] success, error in
        if success {
          
          let message: Message = CoreDataService.shared.add(.message)
          message.messageId = Message.generateMessageId()
          message.date = Date()
          message.conversation = self?.conversation
          message.isIncoming = false
          message.messageText = text
          
          message.lastMessageInConversation = self?.conversation
          
          CoreDataService.shared.save()
          
          
          self?.inputTextField.text = nil
          self?.sendButtonLocked = true
        } else {
          let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "done", style: .cancel))
          self?.present(alert, animated: true)
        }
      }
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.white
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
    
    inputTextField.delegate = self
    inputTextField.layer.borderWidth = 1
    inputTextField.layer.cornerRadius = 5
    inputTextField.placeholder = "Enter mesage"
    inputTextField.autocorrectionType = UITextAutocorrectionType.no
    
    sendButton.layer.borderWidth = 1
    sendButton.layer.cornerRadius = 5
    
    let fetchRequest: NSFetchRequest<Message> = CoreDataService.shared.fetchRequest(.messagesInConversation, dictionary: ["conversationId": conversation.conversationId!])!
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    frcManager.delegate = tableView
    fetchedResultsController = CoreDataService.shared.setupFRC(fetchRequest, frcManager: frcManager)
    CoreDataService.shared.fetchData(fetchedResultsController!)
    
    
    if let count = conversation.messages?.count, count > 0 {
      tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    // adding observers
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(inputModeDidChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    if self.conversation.isOnline {
      self.turnControlsOn()
    } else {
      self.turnControlsOff()
    }
    
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    // removing observers
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    
    self.conversation.hasUnreadMessages = false
    CoreDataService.shared.save()
    
    
    view.gestureRecognizers?.removeAll()
    
  }
  
  
  @objc private func reloadData() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  
  func isEmojiKeyboard() -> Bool {
    return textInputMode?.primaryLanguage == "emoji" || textInputMode?.primaryLanguage == nil
  }
  
  
  @objc func inputModeDidChange(sender: NSNotification) {
    
    if isEmojiKeyboard(){
      print("is emoji")
      view.frame.origin.y += 216.0
    }
    
  }
  
  
  @objc func keyboardWillShow(sender: NSNotification) {
    if view.frame.origin.y < 0.0 {
      view.frame.origin.y += 42.0
      return
    }
    
    if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      view.frame.origin.y -= keyboardSize.height
    }
  }
  
  
  @objc func keyboardWillHide(sender: NSNotification) {
    if isEmojiKeyboard(){
      view.frame.origin.y += 42.0
      return
    }
    
    if view.frame.origin.y >= 0.0 {
      return
    }
    
    if let keyboardSize = (sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      view.frame.origin.y += keyboardSize.height
    }
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
  
  
  @objc private func textFieldDidChange(_ textField: UITextField) {
    if textField == inputTextField {
      if let text = inputTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
        sendButtonLocked = false
      } else {
        sendButtonLocked = true
      }
    }
  }
  
  
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}



// MARK: - UITableViewDataSource , UITableViewDelegate
extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = fetchedResultsController?.sections?.count else {
      return 0
    }
    
    return sections
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    
    return sections[section].numberOfObjects
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let message = fetchedResultsController.object(at: indexPath)
    
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
  
  
  // delete implementation
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      //remove from coredata here
      // ...
  
    }
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
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    let newLength = text.count + string.count - range.length
    return newLength <= 300
  }
  
}



// MARK: - AllowControlsDelegate
extension ConversationViewController: AllowControlsDelegate {
  
  func turnControlsOn() {
    DispatchQueue.main.async {
      self.textFieldDidChange(self.inputTextField)
      self.inputTextField.isEnabled = true
    }
  }
  
  func turnControlsOff() {
    DispatchQueue.main.async {
      self.sendButtonLocked = true
      self.inputTextField.isEnabled = false
    }
  }
  
}
