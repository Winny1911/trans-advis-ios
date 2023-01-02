//
//  CreateAccountModel.swift
//  TA
//
//  Created by Applify  on 12/12/21.
//

import Foundation
import UIKit
class CreateAccountModel {
    var userImage: UIImage = UIImage()
    var userImageName: String = ""
    var isImageSelected: Bool = Bool()
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var skillSet: [String] = [String]()
    
    init() {
    }
    
    init(firstName: String, lastName: String, userImage:UIImage, isImageSelected: Bool, phoneNumber: String, skillSet: [String], userImageName:String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userImage = userImage
        self.isImageSelected = isImageSelected
        self.phoneNumber = phoneNumber
        self.skillSet = skillSet
        self.userImageName = userImageName
    }
}

class CreateAccountLicenseModel {
    var licenseImage: [UIImage]?  // = UIImage()
    var islicenseImageSelected: Bool = Bool()
    var licenseNumber: String = ""
    var licenseSelectedName: [String]? //= ""
    var licenseSelectedImage: [String]? //= ""
    
    init() {
    }
    
    init(licenseNumber: String, licenseImage: [UIImage], islicenseImageSelected: Bool,licenseSelectedName: [String], licenseSelectedImage: [String]) {
        self.licenseNumber = licenseNumber
        self.licenseImage = licenseImage
        self.islicenseImageSelected = islicenseImageSelected
        self.licenseSelectedName = licenseSelectedName
        self.licenseSelectedImage = licenseSelectedImage
    }
}


class CreateAccountLocationModel {
    
    var findLocation: String = ""
    var addressLine1: String = ""
    var addressLine2: String = ""
    var city: String = ""
    var state: String = ""
    var zipcode: String = ""
    
    init() {
    }
    
    init(findLocation: String,addressLine1: String,addressLine2: String,city: String,state: String,zipcode: String) {
        self.findLocation = findLocation
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.state = state
        self.zipcode = zipcode
    }
}

class CreateAccountBankModel {
    var accountNumber: String = ""
    var accountName: String = ""
    var routing: String = ""
    var ssn: String = ""
    
    init() {
    }
    
    init(accountNumber: String,accountName: String,routing: String,ssn: String) {
        self.accountNumber = accountNumber
        self.accountName = accountName
        self.routing = routing
        self.ssn = ssn
    }
}


