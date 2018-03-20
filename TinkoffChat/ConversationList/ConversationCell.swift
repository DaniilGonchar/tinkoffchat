//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by comandante on 3/20/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
  
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var recentMessageLabel: UILabel!
  @IBOutlet weak var recentDateLabel: UILabel!
  
  var name: String? {
    didSet {
      guard let name = name else {
        // stub in case we dont have name
        nameLabel.text = "Name"
        return
      }
      nameLabel.text = name
    }
  }
  
  
  var message: String? {
    didSet {
      recentMessageLabel.text = message == nil ? "No messages yet." : message
      setMessageFont()
    }
  }
  
  
  var date: Date? {
    didSet {
      guard let date = date else {
        // stub in case we dont have date
        recentDateLabel.text = "Date"
        return
      }
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = Calendar.current.isDateInToday(date) ? "HH:mm" : "dd MMM"
      recentDateLabel.text = dateFormatter.string(from: date)
    }
  }
  
  
  var online: Bool = false {
    didSet {
      backgroundColor = online ? #colorLiteral(red: 1, green: 1, blue: 0.8980392157, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
  }
  
  
  var hasUnreadMessages: Bool = false {
    didSet {
      setMessageFont()
    }
  }
  
  
  private func setMessageFont() {
    if message == nil {
      recentMessageLabel.font = .italicSystemFont(ofSize: 15)
    } else if hasUnreadMessages {
      recentMessageLabel.font = .boldSystemFont(ofSize: 15)
    } else {
      recentMessageLabel.font = .systemFont(ofSize: 15)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    userImage.layer.cornerRadius = userImage.frame.size.width / 2
    nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
