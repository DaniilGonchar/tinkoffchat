//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by comandante on 3/21/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {
  
  @IBOutlet weak var gradientImage: UIImageView!
  @IBOutlet weak var messageTextLabel: UILabel!
  
  var messageText: String? {
    didSet {
      messageTextLabel.text = messageText
    }
  }
  
  var isIncoming: Bool = false
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    gradientImage.layer.cornerRadius = 15
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
