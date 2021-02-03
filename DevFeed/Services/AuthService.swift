//
//  AuthService.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, completion: @escaping (_ status: Bool,_ error: Error?)->()){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                completion(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            completion(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, completion: @escaping (_ status: Bool,_ error: Error?)->()){
        Auth.auth().signIn(withEmail: email, link: password) { (result, error) in
            guard let user = result?.user else {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
    
}
