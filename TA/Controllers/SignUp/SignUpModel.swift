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
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var emailVerified: Int = 0
    var state: String = ""
    var city: String = ""
    var addressLine1: String = ""
    var latitude: String = "0"
    var longitude: String = "0"
    var zipCode: String = ""
    var deviceToken: String = ""
    var deviceType: String = ""
    var companyName: String = ""
    
    init() {
    }
    
    init(email: String,
         password: String,
         userType: String,
         termsAccepted:Bool,
         firstName: String,
         lastName: String,
         phoneNumber: String,
         emailVerified: Int,
         state: String,
         city: String,
         addressLine1: String,
         latitude: String,
         longitude: String,
         zipCode: String,
         deviceToken: String,
         deviceType: String,
         companyName: String)
    {
        self.email = email
        self.password = password
        self.userType = userType
        self.termsAccepted = termsAccepted
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.emailVerified = emailVerified
        self.state = state
        self.city = city
        self.addressLine1 = addressLine1
        self.latitude = latitude
        self.longitude = longitude
        self.zipCode = zipCode
        self.deviceType = deviceType
        self.companyName = companyName
    }
    
}
