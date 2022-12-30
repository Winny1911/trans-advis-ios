//
//  ChangePasswordValidationModel.swift
//  TA
//
//  Created by Designer on 04/01/22.
//

import Foundation

class ChangePasswordModel {
    var oldPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    init() {
    }
    
    init(oldPassword: String, newPassword: String, confirmPassword:String) {
        self.oldPassword = oldPassword
        self.newPassword = newPassword
        self.confirmPassword = confirmPassword
    }
}
