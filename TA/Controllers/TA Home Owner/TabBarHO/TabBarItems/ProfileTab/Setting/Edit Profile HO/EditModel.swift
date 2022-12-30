//
//  EditModel.swift
//  TA
//
//  Created by Designer on 05/01/22.
//

import Foundation

import UIKit
class EditModel {
//    var userImage: UIImage = UIImage()
//    var userImageName: String = ""
//    var isImageSelected: Bool = Bool()
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    var skillSet: String = ""
//    var skillSet: [String] = [String]()
    var street: String = ""
    var city: String = ""
    var state: String = ""
    var zipCode: String = ""
    var licenceNumber: String = ""
    init() {
    }
    
//    init(firstName: String, lastName: String, userImage:UIImage, isImageSelected: Bool, phoneNumber: String, skillSet: [String], userImageName:String, street: String, city: String, state:String, zipCode:String) {
    init(firstName: String, lastName: String, phoneNumber: String, skillSet: String, street: String, city: String, state:String, zipCode:String, licenceNumber:String) {
        self.firstName = firstName
        self.lastName = lastName
//        self.userImage = userImage
        self.licenceNumber = licenceNumber
        self.phoneNumber = phoneNumber
        self.skillSet = skillSet
//        self.userImageName = userImageName
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}
