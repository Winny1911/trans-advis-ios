//
//  OrderListDetailsModel.swift
//  TA
//
//  Created by iOS on 03/10/22.
//

import Foundation

// MARK: - OrderListDetailsModel
struct OrderListDetailsModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: OrderListDetailsData?
}

// MARK: - DataClass
struct OrderListDetailsData: Codable {
    let id, projectID, vendorID, contractorID: Int?
    let subtaskID, status, isContractor, isVendor: Int?
    let createdAt, updatedAt: String?
    let finalAmount, vendorAmount: Int?
    let addressLine1, addressLine2, zipCode, city: String?
    let state, country: String?
    let isBlocked, isDeleted, discount, totalItem: Int?
    let totalPrice, vendorDisputeResolved, contractorDisputeResolved, vendorRaisedDispute: Int?
    let contractorRaisedDispute: Int?
    let cartItem: [CartItemss]?
    let vendorDetail, cartContractor: CartContractorss?
    let dispute: [Disputess]?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case vendorID = "vendorId"
        case contractorID = "contractorId"
        case subtaskID = "subtaskId"
        case status, isContractor, isVendor, createdAt, updatedAt, finalAmount, vendorAmount, addressLine1, addressLine2, zipCode, city, state, country, isBlocked, isDeleted, discount
        case totalItem = "TotalItem"
        case totalPrice = "TotalPrice"
        case vendorDisputeResolved, contractorDisputeResolved, vendorRaisedDispute, contractorRaisedDispute
        case cartItem = "Cart_Item"
        case vendorDetail = "vendor_detail"
        case cartContractor = "cart_contractor"
        case dispute
    }
}

// MARK: - CartContractor
struct CartContractorss: Codable {
    let id: Int?
    let firstName, lastName, email: String?
}

// MARK: - CartItem
struct CartItemss: Codable {
    let id, productID, cartID: Int?
    let item: String?
    let status, price, quantity, isDeleted: Int?
    let createdAt, updatedAt, productCategoresName: String?
    let productsss: Productsssss?

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "productId"
        case cartID = "cartId"
        case item, status, price, quantity, isDeleted, createdAt, updatedAt, productCategoresName, productsss
    }
}

// MARK: - Productsss
struct Productsssss: Codable {
    let id: Int?
    let category: String?
//    let productFiles: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id, category
//        case productFiles = "product_files"
    }
}

// MARK: - Dispute
struct Disputess: Codable {
    let id, projectID, userID, cartID: Int?
    let userType: Int?
    let amount, refundedAmount, reason: String?
    let subTaskID, isAdminResolved, isRefund: Int?
//    let addComment: JSONNull?
    let status, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case userID = "userId"
        case cartID = "cartId"
        case userType, amount, refundedAmount, reason
        case subTaskID = "subTaskId"
        case isAdminResolved, isRefund
//        case addComment = "AddComment"
        case status, isBlocked, isDeleted, createdAt, updatedAt
    }
}
