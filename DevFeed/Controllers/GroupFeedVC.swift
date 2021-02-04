//
//  GroupFeedVC.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    
    
    @IBOutlet weak var membersLbl: UILabel!
    
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var sendView: UIView!
    
    var group: Group?
    var groupMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendView.bindToKeyboard()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func initData(group: Group){
        self.group = group
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitle.text = group?.groupTitle
        membersLbl.text = group?.members.joined(separator: ", ")
        
        DataService.instance.getEmailsForGroup(group: group!) { (returnedArray) in
            self.membersLbl.text = returnedArray.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesForGroup(group: self.group!) { (returnedArray) in
                self.groupMessages = returnedArray
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.groupMessages.count-1, section: 0), at: .none, animated: true)
                }
            }
        }
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if messageField.text != "" {
            sendBtn.isEnabled = false
            messageField.isEnabled = false
            DataService.instance.uploadPost(message: messageField.text!, uid: (Auth.auth().currentUser?.uid)!, groupKey: group?.key) { (success) in
                if success {
                    self.messageField.text = ""
                    self.sendBtn.isEnabled = true
                    self.messageField.isEnabled = true
                }
            }
        }
    }
    
    

}


extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell") as? GroupFeedCell else {return UITableViewCell()}
        let message = groupMessages[indexPath.row]
        DataService.instance.getUsername(uid: message.senderId) { (email) in
            cell.configureCell(profileImg: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
        }
        return cell
    }
        
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
