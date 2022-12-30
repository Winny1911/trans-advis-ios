//
//  SignUpModel.swift
//  TA
//
//  Created by Applify  on 10/12/21.
//

import Foundation

class SignupModel {
    
    var email: String = ""
    var password: String = ""
    var userType: String = ""
    var termsAccepted: Bool = false
    
    init() {
    }
    
    init(userType: String, email: String, password: String, termsAccepted:Bool) {
        self.userType = userType
        self.email = email
        self.password = password
        self.termsAccepted = termsAccepted
    }
    
}
