//
//  TransactionCOResponseModel.swift
//  TA
//
//  Created by Applify  on 14/01/22.
//

import Foundation
struct TransactionCOResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : TransactionCOResponseDetail?
}

struct TransactionCOResponseDetail : Codable {
    var Available : Int?
    var BAlance : Double?
    var ContractorFund : Int?
    var EstimatedPrfitLoss : Int?
    var SubContractorFund : Int?
    var TAcommisssion : Double?
    var Tasks : [TasksDetailss]?
    var Cart : [CartDetailss]?
    var TotalSpent : Int?
    var amountCurrency : String?
    var bidAmount : String?
    var bidFloatAmount : Int?
    var bids : [BidsDetails]?
    var description : String?
    var finalPrice : Int?
    var id : Int?
    var price : Int?
    var spent : Int?
    var title : String?
    var type : String?
    var userId : Int?
}

struct CommonTaskCartDetails: Codable {
    var lastName : String?
    var firstName : String?
    var taskType :Int?
    var amount : Int?
    var dateTime :String?
    var status: Int
}

// MARK: - Task
struct CartDetailss: Codable {
    var CartUser : CartDetailz?
    var CartVendorUser : VendorDetailz?
    var addressLine1 : String?
    var addressLine2 : String?
    var city : String?
    var completDateByAdmin : String?
    var contractorId : Int?
    var country : String?
    var createdAt : String?
    var discount : Int?
    var finalAmount : Int?
    var id : Int?
    var isBlocked : Int?
    var isContractor : Int?
    var isDeleted : Int?
    var isVendor : Int?
    var paymentStatus : Int?
    var projectId : Int?
    var state : String?
    var status : Int?
    var subTaskId : Int?
    var updatedAt : String?
    var vendorAmount : Int?
    var vendorId : Int?
    var zipCode : String?
    var cartDispute: [CardDisputeList]?
    
}

struct CardDisputeList: Codable {
    var id : Int?
    var projectId: Int?
    var isRefund : Int?
    var refundedAmount : String?
}

struct CartDetailz: Codable {
    var email : String?
    var id : Int?
    var lastName : String?
    var firstName : String?
}

struct VendorDetailz: Codable {
    var email : String?
    var id : Int?
    var lastName : String?
    var firstName : String?
}

// MARK: - Task
struct TasksDetails: Codable {
    let id, userID, projectID: Int?
    let type, task: String?
    let status, budget: Int?
    var TaskType: Int?
    let createdAt: String?
    var assginee: Assginee?

    enum CodingKeys: String, CodingKey {
        case id
        case TaskType
        case userID = "userId"
        case projectID = "projectId"
        case type, task, status, budget, createdAt
        case assginee = "Assginee"
    }
}
