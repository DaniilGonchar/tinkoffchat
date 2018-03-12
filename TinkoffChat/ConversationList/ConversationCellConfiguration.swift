//
//  ConversationListCell.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

class ConversationCellConfiguration: UITableViewCell { //ConversationCellConfiguration  ConversationListCell
    
     @IBOutlet weak var userImage: UIImageView!
     @IBOutlet weak var nameLabel: UILabel!
     @IBOutlet weak var recentMessageLabel: UILabel!
     @IBOutlet weak var recentDateLabel: UILabel!

    var name: String?
    var message: String?
    var date: Date?
    var online: Bool?
    var hasUnreadMessages: Bool?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        //recentMessageLabel.font = UIFont.italicSystemFont(ofSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
