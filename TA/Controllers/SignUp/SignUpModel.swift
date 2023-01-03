//
//  SignUpModel.swift
//  TA
//
//  Created by Applify  on 10/12/21.
//

import Foundation

class SignupModel {
    
    var email: String? = ""
    var password: String? = ""
    var userType: String? = ""
    var termsAccepted: Bool? = false
    var id: Int? = 0
    var firstName: String? = ""
    var lastName: String? = ""
    var fullName: String? = ""
    var profilePic: String? = ""
    var phoneNumber: String? = ""
    var otp: String? = ""
    var accessToken: String? = ""
    var resetPasswordToken: String? = ""
    var licenceNumber: String? = ""
    var skillSet: String? = ""
    var emailVerified: Int? = 0
    var country: String? = ""
    var state: String? = ""
    var city: String? = ""
    var addressLine1: String? = ""
    var addressLine2: String? = ""
    var latitude: String? = "0"
    var longitude: String? = "0"
    var zipCode: String? = ""
    var forgotPasswordGeneratedAt: String? = ""
    var profileStatus: String? = ""
    var isBlocked: String? = ""
    var isDeleted: String? = ""
    var createdAt: String? = ""
    var updatedAt: String? = ""
    var aboutBio: String? = ""
    var venderDeepLink: String? = ""
    var contractorDeepLink: String? = ""
    var emailVerificationToken: String? = ""
    var deviceToken: String? = ""
    var deviceType: String? = ""
    var expiredAt: String? = ""
    var rating: String? = ""
//    var user_files: [UserFile]?
//    var userDocuments: [UserDocumentsDetails]?
//    var userSkills: [UserSkill]?
    
    init() {
    }
    
    init(userType: String? = "",
         email: String? = "",
         password: String? = "",
         termsAccepted:Bool? = false,
         id: Int? = 0,
         firstName: String? = "",
         lastName: String? = "",
         fullName: String? = "",
         profilePic: String? = "",
         phoneNumber: String? = "",
         otp: String? = "",
         accessToken: String? = "",
         resetPasswordToken: String? = "",
         licenceNumber: String? = "",
         skillSet: String? = "",
         emailVerified: Int? = 0,
         country: String? = "",
         state: String? = "",
         city: String? = "",
         addressLine1: String? = "",
         addressLine2: String? = "",
         latitude: String? = "",
         longitude: String? = "",
         zipCode: String? = "",
         forgotPasswordGeneratedAt: String? = "",
         profileStatus: String? = "",
         isBlocked: String? = "",
         isDeleted: String? = "",
         createdAt: String? = "",
         updatedAt: String? = "",
         aboutBio: String? = "",
         venderDeepLink: String? = "",
         contractorDeepLink: String? = "",
         emailVerificationToken: String? = "",
         deviceToken: String? = "",
         deviceType: String? = "",
         expiredAt: String? = "",
         rating: String? = "")
//         user_files: [UserFile],
//         userDocuments: [UserDocumentsDetails],
//         userSkills: [UserSkill])
    {
        self.userType = userType
        self.email = email
        self.password = password
        self.termsAccepted = termsAccepted
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.profilePic = profilePic
        self.phoneNumber = phoneNumber
        self.otp = otp
        self.accessToken = accessToken
        self.resetPasswordToken = resetPasswordToken
        self.licenceNumber = licenceNumber
        self.skillSet = skillSet
        self.emailVerified = emailVerified
        self.country = country
        self.state = state
        self.city = city
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.latitude = latitude
        self.longitude = longitude
        self.zipCode = zipCode
        self.forgotPasswordGeneratedAt = forgotPasswordGeneratedAt
        self.profileStatus = profileStatus
        self.isBlocked = isBlocked
        self.isDeleted = isDeleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.aboutBio = aboutBio
        self.venderDeepLink = venderDeepLink
        self.contractorDeepLink = contractorDeepLink
        self.emailVerificationToken = emailVerificationToken
        self.deviceToken = deviceToken
        self.deviceType = deviceType
        self.expiredAt = expiredAt
        self.rating = rating
//        self.user_files = user_files
//        self.userDocuments = userDocuments
//        self.userSkills = userSkills
    }
    
}
