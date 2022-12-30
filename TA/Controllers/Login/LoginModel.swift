//
//  LoginModel.swift
//  TA
//
//  Created by Applify  on 09/12/21.
//

import Foundation

class LoginModel {
    var email: String = ""
    var password: String = ""
    
    init() {
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
