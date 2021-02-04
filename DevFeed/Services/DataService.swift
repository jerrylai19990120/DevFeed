//
//  DataService.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    func createDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadPost(message: String, uid: String, groupKey: String?, completion: @escaping (_ status:Bool)->()){
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderID": uid])
            completion(true)
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderID": uid])
            completion(true)
        }
    }
    
    func getAllFeedMessages(completion: @escaping (_ messages: [Message])->()){
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for feedMessage in feedMessageSnapshot {
                let content = feedMessage.childSnapshot(forPath: "content").value as! String
                let senderId = feedMessage.childSnapshot(forPath: "senderID").value as! String
                
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
                
            }
            
            completion(messageArray)
        }
    }
    
    func getUsername(uid: String, handler: @escaping (_ username: String)->()){
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func getEmail(query: String, handler: @escaping (_ emailArray: [String])->()){
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) && email != Auth.auth().currentUser?.email{
                    emailArray.append(email)
                }
            }
            
            handler(emailArray)
        }
    }
    
    func getIds(usernames: [String], handler: @escaping (_ uidArray: [String])->()){
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshots = snapshot.children.allObjects as? [DataSnapshot] else {return}
            var idArray = [String]()
            for user in userSnapshots {
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if usernames.contains(email) {
                    idArray.append(user.key)
                }
            }
            
            handler(idArray)
        }
    }
    
    func createGroup(title: String, description: String, ids: [String], handler: @escaping (_ status: Bool)->()) {
        REF_GROUPS.childByAutoId().updateChildValues([
            "title": title,
            "description": description,
            "members": ids
        ])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groups: [Group])->()){
        
        var groupArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            guard let groupSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                let title = group.childSnapshot(forPath: "title").value as! String
                let desc = group.childSnapshot(forPath: "description").value as! String
                
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let group_1 = Group(title: title, description: desc, key: group.key, members: memberArray, memberCount: memberArray.count)
                    groupArray.append(group_1)
                }
            }
            
            handler(groupArray)
        }
    }
    
    func getEmailsForGroup(group: Group, handler: @escaping (_ emails: [String])->()){
        var emailArray = [String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            
            handler(emailArray)
        }
        
    }
    
    func getAllMessagesForGroup(group: Group, handler: @escaping (_ messages: [Message])->()){
        var groupMessageArray = [Message]()
        REF_GROUPS.child(group.key).child("messages").observeSingleEvent(of: .value) { (snapshot) in
            guard let groupMessage = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for message in groupMessage {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderID").value as! String
                let message = Message(content: content, senderId: senderId)
                groupMessageArray.append(message)
            }
            handler(groupMessageArray)
        }
    }
    
}
