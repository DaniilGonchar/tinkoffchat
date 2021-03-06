//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by comandante on 3/21/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration {
  var messageText: String? { get set }
  var isIncoming: Bool { get set }
}


class MessageCell: UITableViewCell, MessageCellConfiguration {
  
  @IBOutlet weak var messageLabel: UILabel!
  
  var messageText: String? {
    didSet {
      messageLabel.text = messageText
    }
  }
  
  var isIncoming = false
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    messageLabel.superview?.layer.cornerRadius = 15
  }
  
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}


