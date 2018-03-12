//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by comandante on 3/8/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

// this extension is needed to make "light-yellow" background for unread messages
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
//        switch hex.characters.count {
         switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}



class TestMessageClass: NSObject {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool?
    var hasUnreadMessages: Bool?
    
    init(pname: String, pmessage: String , pdate: Date, ponline: Bool, phasUnreadMessages: Bool)
    {
        self.name = pname
        self.message = pmessage
        self.date = pdate
        self.online = ponline
        self.hasUnreadMessages = phasUnreadMessages
        
    }
    
    // init without message
    init(pname: String,  pdate: Date, ponline: Bool, phasUnreadMessages: Bool)
    {
        self.name = pname
        self.date = pdate
        self.online = ponline
        self.hasUnreadMessages = phasUnreadMessages
        
    }
}







class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    
    var nameStringPressed: String?
    var arrayOfTestMessages = [TestMessageClass]()
    
    
    
    
    // Handling TableView stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0)
        {
            return "Online"
        }
        else
        {
            return "History"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        var onlineCounter = 0
        var offlineCounter = 0
        
        for i in 0..<arrayOfTestMessages.count
        {
            if (arrayOfTestMessages[i].online)!
            { onlineCounter = onlineCounter + 1 }
            else
            {
                offlineCounter = offlineCounter + 1
            }
        }
        
        if (section == 0) // "online" section
        { return onlineCounter }
        else { return offlineCounter } // "offline" section
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let conversationListCell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! ConversationCellConfiguration
        
        // "cancelling changes"
        conversationListCell.recentMessageLabel.font = UIFont.systemFont(ofSize: 15)
        conversationListCell.backgroundColor = UIColor.white
        conversationListCell.recentDateLabel.isHidden = false
        
        
        
        let temporaryTestMessage: TestMessageClass
        if (indexPath.section == 0 )
        {
        temporaryTestMessage = arrayOfTestMessages[indexPath.row]
        }
        else
        {// +10 offset stand for online group
        temporaryTestMessage = arrayOfTestMessages[indexPath.row + 10]
        }
        
        conversationListCell.message = temporaryTestMessage.message
        conversationListCell.date = temporaryTestMessage.date
        conversationListCell.name = temporaryTestMessage.name
        conversationListCell.hasUnreadMessages = temporaryTestMessage.hasUnreadMessages
        conversationListCell.online = temporaryTestMessage.online
        
        
        // setting things up in cell
        conversationListCell.nameLabel.text = conversationListCell.name
        if ( conversationListCell.message == nil ){
            conversationListCell.recentMessageLabel.text = "No messages yet."
            conversationListCell.recentDateLabel.isHidden = true
            conversationListCell.recentMessageLabel.font = UIFont(name: "Georgia-Italic", size: 15.0)
        }
        else{
            // if we have unread message -> make it BOLD
            if ( conversationListCell.hasUnreadMessages)!{
                conversationListCell.recentMessageLabel.font = UIFont.boldSystemFont(ofSize: 15)
            }
            conversationListCell.recentMessageLabel.text = conversationListCell.message
        }
        
        
        
        
        
        
        
        
        // date handling
        
        let calendar = NSCalendar.current
        let date = conversationListCell.date
    
        if calendar.isDateInToday(date!) {
            // today case
            let hhmmFormatter = DateFormatter()
            hhmmFormatter.dateFormat = "HH:mm"
            conversationListCell.recentDateLabel.text = hhmmFormatter.string(from: conversationListCell.date!)
            }
        
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date!)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 {
                 // print("\(abs(day)) days ago
                let ddmmFormatter = DateFormatter()
                ddmmFormatter.dateFormat = "dd MMM" 
                conversationListCell.recentDateLabel.text = ddmmFormatter.string(from: conversationListCell.date!)
            }
        }
        
        // date end
        
        
        
        
        
        
        // if user is online -> make background YELLOW
        if (conversationListCell.online)!
        {
            conversationListCell.backgroundColor = UIColor(hexString: "#ffffe5")//UIColor.yellow
        }
        
        
        
        
        return conversationListCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let conversationListCell = tableView.cellForRow(at: indexPath) as! ConversationCellConfiguration
        
        nameStringPressed = conversationListCell.nameLabel.text
        
        self.performSegue(withIdentifier: "showChatSegue" , sender: self)
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        // creating some messages for testing purposes as data source for tableview cells
        
        //online
        arrayOfTestMessages.append(TestMessageClass(pname: "Jack Douglas", pmessage: "hey how is it going?", pdate: Date(), ponline: true, phasUnreadMessages: true))
        arrayOfTestMessages.append(TestMessageClass(pname: "Sam Smith", pmessage: "got it.", pdate: Date(), ponline: true, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Sonia Aldred", pmessage: "txt(debug:online,no unread)", pdate: Date(), ponline: true, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Tyreece Barrow", pmessage: "txt(debug:online,has unread)", pdate: Date(), ponline: true, phasUnreadMessages: true))
        
        
        
        // simulating old date -- 542325951 sec == 2018/03/10  (03 stands for month)
        
        //  542412351 == 2018/03/11

        let someOldDate = Date(timeIntervalSinceReferenceDate: 542412351)
        
        arrayOfTestMessages.append(TestMessageClass(pname: "Zeshan Devlin",  pmessage: "ut labore et dolore magna ", pdate: someOldDate, ponline: true, phasUnreadMessages: false))
        
        let anotherOldDate = Date(timeIntervalSinceReferenceDate: 542325951)
        
        arrayOfTestMessages.append(TestMessageClass(pname: "Rea Sharma", pmessage: "ut labore et dolore magna ", pdate: anotherOldDate, ponline: true, phasUnreadMessages: false))
        
        
        
        
        arrayOfTestMessages.append(TestMessageClass(pname: "August Ventura Long Long Name", pmessage: "quis nostrud exercitation ", pdate: Date(), ponline: true, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Lea Ratliff", pmessage: "in reprehenderit in voluptate ", pdate: Date(), ponline: true, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Willis Duggan",  pdate: Date(), ponline: true, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Darlene Knowles", pdate: Date(), ponline: true, phasUnreadMessages: false))
        
        
        
        //history
        arrayOfTestMessages.append(TestMessageClass(pname: "Mary Black", pmessage: "i have seen it!", pdate: Date(), ponline: false, phasUnreadMessages: true))
        arrayOfTestMessages.append(TestMessageClass(pname: "Jay Baldwin", pmessage: "man it looks gorgeous", pdate: Date(), ponline: false, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Kim Mack Really long name thing", pmessage: "another offline msg", pdate: anotherOldDate, ponline: false, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "John Lee", pmessage:"txt(debug:offline,no unread)",  pdate: Date(), ponline: false, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Tabatha Haworth Name Is so Long it wont fit", pmessage: "txt(debug:ofline,has unread)", pdate: Date(), ponline: false, phasUnreadMessages: true))
        arrayOfTestMessages.append(TestMessageClass(pname: "Jonas Walsh", pmessage: "delectus legendos est te, ne habeo", pdate: someOldDate, ponline: false, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Kieron Wilkerson", pmessage: "Quot tollit atomorum ea sed", pdate: Date(), ponline: false, phasUnreadMessages: false))
        arrayOfTestMessages.append(TestMessageClass(pname: "Abdul Barclay", pmessage: "et dico iracundia vix", pdate: Date(), ponline: false, phasUnreadMessages: true))
        arrayOfTestMessages.append(TestMessageClass(pname: "Kelan Morrison", pmessage: "Sale primis quo no", pdate: Date(), ponline: false, phasUnreadMessages: true))
        arrayOfTestMessages.append(TestMessageClass(pname: "Rehaan Larson", pmessage: "eam cu persecuti intellegebat", pdate: Date(), ponline: false, phasUnreadMessages: false))
        
        // finished creating
        
        
        
        setupNavigationBarItems()

        
    }
    
    private func setupNavigationBarItems(){

        let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "user-512"), style: .plain , target: self, action: #selector(self.profileButtonFunc) )
        
        profileButton.tintColor = UIColor.gray
        navigationItem.rightBarButtonItem = profileButton
        
        

    }
    
    @objc func profileButtonFunc(){
        self.performSegue(withIdentifier: "showProfileSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showChatSegue"){
        let chatViewController = segue.destination as! ConversationViewController
        
        chatViewController.recievedNameString = nameStringPressed!
        }
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
