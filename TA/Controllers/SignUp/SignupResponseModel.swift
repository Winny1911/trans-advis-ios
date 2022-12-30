//
//  SignupResponseModel.swift
//  TA
//
//  Created by Applify  on 09/12/21.
//

import Foundation

struct SignupResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : signupDataDetail?
}

struct VerifyUser : Codable {
    var message : String?
    var statusCode : Int?
}

struct signupDataDetail : Codable {
    var accessToken : String?
    var addressLine1 : String?
    var addressLine2 : String?
    var city : String?
    var country : String?
    var createdAt : String?
    var deviceToken : String?
    var deviceType : String?
    var email : String?
    var emailVerificationToken : String?
    var emailVerified : String?
    var expiredAt : String?
    var firstName : String?
    var latitude : String?
    var longitude : String?
    var forgotPasswordGeneratedAt : String?
    var fullName : String?
    var id : Int?
    var isBlocked : String?
    var isDeleted : String?
    var lastName : String?
    var licenceNumber : String?
    var otp : String?
    var password : String?
    var phoneNumber : String?
    var profilePic : String?
    var profileStatus : String?
    var resetPasswordToken : String?
    var skillSet : String?
    var state : String?
    var updatedAt : String?
    var userType : String?
    var zipCode : String?
    var userDocuments : [UserDocumentsDetails]?
    var user_files : [UserFilesDetails]?
}

struct UserFilesDetails : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
}

struct UserDocumentsDetails : Codable {
    var createdAt : String?
    var file : String?
    var id : Int?
    var title : String?
    var type : String?
    var updatedAt : String?
}

struct UserProfileResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : UserProfileDataDetail?
}

struct UserProfileDataDetail : Codable {
    var accessToken : String?
    var addressLine1 : String?
    var addressLine2 : String?
    var city : String?
    var country : String?
    var createdAt : String?
    var deviceToken : String?
    var deviceType : String?
    var email : String?
    var emailVerificationToken : String?
    var emailVerified : Int?
    var expiredAt : String?
    var firstName : String?
    var longitude : String?
    var latitude : String?
    var forgotPasswordGeneratedAt : String?
    var fullName : String?
    var id : Int?
    var isBlocked : Int?
    var isDeleted : Int?
    var lastName : String?
    var licenceNumber : String?
    var otp : String?
    var password : String?
    var phoneNumber : String?
    var profilePic : String?
    var profileStatus : Int?
    var resetPasswordToken : String?
    var skillSet : String?
    var state : String?
    var updatedAt : String?
    var userType : String?
    var zipCode : String?
    var userDocuments : [UserDocumentsDetails]?
    var user_files : [UserFilesDetails]?
    var userSkills : [UserSkillsDetail]?
}
struct UserSkillsDetail : Codable {
    var id : Int?
    var name : String?
    var accessToken : String?
    var projectCategory : ProjectCategoryDetail?
    var skillId : Int?
    var userId : Int?
}

struct ProjectCategoryDetail : Codable {
    var id : Int?
    var title : String?
}
