//
//  Message.swift
//  DevFeed
//
//  Created by Jerry Lai on 2021-02-03.
//  Copyright © 2021 Jerry Lai. All rights reserved.
//

import Foundation

class Message {
    
    private var _content: String
    private var _senderID: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderID
    }
    
    init(content: String, senderId: String){
        self._content = content
        self._senderID = senderId
    }
    

}
