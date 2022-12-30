//
//  SkillsModel.swift
//  TA
//
//  Created by Applify  on 14/12/21.
//

import Foundation

struct SentTaskResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : SentTaskResponseModeDetail?
}

struct SentTaskResponseModeDetail : Codable {
    var customMessage : String?
}

struct SkillsResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : SkillsResponseDataDetail?
}

struct SkillsResponseDataDetail : Codable {
    var count : Int?
    var listing : [SkillsResponseDetail]?
}

struct SkillsResponseDetail : Codable {
    var id : Int?
    var title : String?
    var description : String?
    var isBlocked : Int?
}


struct AddBankAccountResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : AddBankAccountResponseDetail?
}
struct AddBankAccountResponseDetail : Codable {
    var SaveData : SaveDataDetail?
}

struct SaveDataDetail : Codable {
    var accountHolderName : String?
    var accountNo : String?
    var bankAddress : String?
    var bankName : String?
    var contractorId : Int?
    var createdAt : String?
    var id : Int?
    var routingNumber : String?
    var ssn : String?
    var updatedAt : String?
}

struct GetBankAccountResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : GetBankAccountResponseData?
}

struct GetBankAccountResponseData : Codable {
     var listing : BankListingDetail?
}

struct BankListingDetail : Codable {
    var accountHolderName : String?
    var accountNo : String?
    var id : Int?
    var routingNumber : String?
    var ssn : String?
}

