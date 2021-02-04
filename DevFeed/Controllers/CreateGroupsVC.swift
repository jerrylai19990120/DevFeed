//
//  CreateGroupsVC.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    
    @IBOutlet weak var titleTxt: InsetTextField!
    
    @IBOutlet weak var descTxt: InsetTextField!
    
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var emailSearchTxt: InsetTextField!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTxt.delegate = self
        emailSearchTxt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(){
        if emailSearchTxt.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(query: emailSearchTxt.text!) { (results) in
                self.emailArray = results
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if titleTxt.text != "" && descTxt.text != "" {
            DataService.instance.getIds(usernames: chosenUserArray) { (ids) in
                var userIds = ids
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(title: self.titleTxt.text!, description: self.descTxt.text!, ids: userIds) { (success) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("cannot create group")
                    }
                }
            }
        }
    }
    
    

}

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else {return UITableViewCell()}
        let img = UIImage(named: "defaultProfileImage")
        
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(email: emailArray[indexPath.row], profileImg: img!, isSelected: true)
            
        } else {
            cell.configureCell(email: emailArray[indexPath.row], profileImg: img!, isSelected: false)
        }
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {return}
        if !chosenUserArray.contains(cell.emailLbl.text!) {
            chosenUserArray.append(cell.emailLbl.text!)
            groupLbl.text = chosenUserArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({$0 != cell.emailLbl.text!})
            if chosenUserArray.count >= 1 {
                groupLbl.text = chosenUserArray.joined(separator: ", ")
                doneBtn.isHidden = false
            } else {
                groupLbl.text = "add people to your group"
                doneBtn.isHidden = true
            }
        }
    }
    
    
}

extension CreateGroupsVC: UITextFieldDelegate {
    
}
