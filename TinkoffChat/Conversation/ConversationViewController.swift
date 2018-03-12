//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

// gradient for message bubbles - WORK IN PROGRESS
//extension UIView{
//
//    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor){
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
//        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
//
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//}




class TestChatMessage: NSObject {
    var messageText: String?
    var isIncoming: Bool?
   
    init(pmessageText: String, pisIncoming: Bool)
    {
        self.messageText = pmessageText
        self.isIncoming = pisIncoming
    }
}







class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var recievedNameString = String()
    
    var arrayOfTestMessages = [TestChatMessage]()
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTestMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //her
        
        
        if (arrayOfTestMessages[indexPath.row].isIncoming)!
        { //incoming message
            
            let myCell = tableView.dequeueReusableCell(withIdentifier: "incomingCell") as! MessageCellConfiguration
            
            
            myCell.selectionStyle = UITableViewCellSelectionStyle.none
            myCell.messageTextLabel.lineBreakMode = .byWordWrapping
            myCell.messageTextLabel.numberOfLines = 0;
            
            myCell.messageText = arrayOfTestMessages[indexPath.row].messageText
            myCell.isIncoming = arrayOfTestMessages[indexPath.row].isIncoming
            
            
            myCell.messageTextLabel.text = myCell.messageText
            
           
//             paint it grey
//             gradient for message bubbles - WORK IN PROGRESS
//            myCell.gradientImage.setGradientBackground(colorOne: UIColor(red: 170.0/255.0 , green: 170.0/255.0, blue: 170.0/255.0, alpha: 1.0) , colorTwo: UIColor(red: 215.0/255.0 , green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0))

            
            return myCell
            
        }
        else{ //outgoing message
            
            let myCell = tableView.dequeueReusableCell(withIdentifier: "outgoingCell") as! MessageCellConfiguration
            
            
            myCell.selectionStyle = UITableViewCellSelectionStyle.none
            myCell.messageTextLabel.lineBreakMode = .byWordWrapping
            myCell.messageTextLabel.numberOfLines = 0;
            
            myCell.messageText = arrayOfTestMessages[indexPath.row].messageText
            myCell.isIncoming = arrayOfTestMessages[indexPath.row].isIncoming
            
            
            myCell.messageTextLabel.text = myCell.messageText
            

//            // paint it blue
//             gradient for message bubbles - WORK IN PROGRESS
//            myCell.gradientImage.setGradientBackground(colorOne: UIColor(red: 0.0/255.0 , green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0) , colorTwo: UIColor(red: 150.0/255.0 , green: 190.0/255.0, blue: 255.0/255.0, alpha: 1.0))
            
            return myCell
            
            
        }
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.navigationItem.title = recievedNameString
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        
        
        
        // creating 6 test messages
        arrayOfTestMessages.append(TestChatMessage(pmessageText: "I", pisIncoming: true))
        arrayOfTestMessages.append(TestChatMessage(pmessageText: "umm", pisIncoming: true))
        
        arrayOfTestMessages.append(TestChatMessage(pmessageText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, qiallum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", pisIncoming: false))
        arrayOfTestMessages.append(TestChatMessage(pmessageText: "Dolor sit amet, conset at teu?", pisIncoming: true))
        arrayOfTestMessages.append(TestChatMessage(pmessageText: "Ut aliq ex ea modo consequat. ", pisIncoming: false))
        arrayOfTestMessages.append(TestChatMessage(pmessageText: "q", pisIncoming: true))
     
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
