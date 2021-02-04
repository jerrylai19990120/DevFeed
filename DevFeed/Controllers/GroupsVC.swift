//
//  SecondViewController.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var groupArray = [Group]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            
            DataService.instance.getAllGroups { (arrayVal) in
                self.groupArray = arrayVal
                self.tableView.reloadData()
            }
        }
        
    }

    @IBAction func addBtnPressed(_ sender: Any) {
        guard let createGroupsVC = storyboard?.instantiateViewController(withIdentifier: "CreateGroupsVC") as? CreateGroupsVC else {return}
        createGroupsVC.modalPresentationStyle = .fullScreen
        present(createGroupsVC, animated: true, completion: nil)
    }
    
}

extension GroupsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as? GroupCell else {return UITableViewCell()}
        let group = groupArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDesc, members: group.memberCount)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else {return}
        groupFeedVC.initData(group: groupArray[indexPath.row])
        presentDetail(groupFeedVC)
    }
    
}
