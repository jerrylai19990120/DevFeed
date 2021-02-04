//
//  MeVC.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userLbl.text = Auth.auth().currentUser?.email
    }
    

    @IBAction func logoutPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Log out?", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                authVC?.modalPresentationStyle = .fullScreen
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                debugPrint("\(error.localizedDescription)")
            }
            
        }
        
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    

}
