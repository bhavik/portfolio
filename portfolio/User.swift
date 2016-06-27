//
//  User.swift
//  portfolio
//
//  Created by Bhavik Shah on 6/17/16.
//  Copyright © 2016 shah. All rights reserved.
//

import UIKit


class User: NSObject {
    var userName: String
    var userEmail: String
    var userId: String
    
    init(userName: String, userEmail: String, userId: String) {
        self.userName = userName
        self.userEmail = userEmail
        self.userId = userId
        super.init()
    }
  
}
