//
//  OrderListResponseModel.swift
//  TA
//
//  Created by Applify  on 21/02/22.
//

import Foundation


struct CartStatusUpadteResponseModel: Codable {
    let statusCode: Int?
    let message: String?
}


// MARK: - VendorProfileCO
struct OrderListResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: [OrderListResponseModelDetails]?
}

struct OrderListDetaisResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: OrderListResponseModelDetails?
}

struct OrderListResponseModelDetails: Codable {
    let Cart_Item: [Cart_ItemDetails]?
    let TotalItem: Int?
    let TotalPrice: Double?
    let addressLine1: String?
    let addressLine2: String?
    let cart_contractor: CartContractorDetails?
    let city: String?
    let contractorId: Int?
    let country: String?
    let createdAt: String?
    let discount: Double?
    let dispute: [DisputeDetails]?
    let finalAmount: Double?
    let id: Int?
    let isBlocked: Int?
    let isContractor: Int?
    let isDeleted: Int?
    let isVendor: Int?
    let projectId: Int?
    let state: String?
    let status: Int?
    let subtaskId: Int?
    let updatedAt: String?
    let vendorAmount: Double?
    let vendorId: Int?
    let vendor_detail: VendorDetail?
    let zipCode: String?
    let vendorDisputeResolved: Int?
    let vendorRaisedDispute: Int?
    let contractorDisputeResolved: Int?
    let contractorRaisedDispute: Int?
}

struct VendorDetail: Codable {
    let email: String?
    let firstName: String?
    let id: Int?
    let lastName: String?
}

struct DisputeDetails: Codable {
    let AddComment: String?
    let amount: String?
    let cartId: Int?
    let createdAt: String?
    let id: Int?
    let isAdminResolved: Int?
    let isBlocked: Int?
    let isDeleted: Int?
    let projectId: Int?
    let reason: String?
    let status: Int?
    let subTaskId: Int?
    let updatedAt: String?
    let userId: Int?
    let userType: Int?
    let refundedAmount: String?
    let isRefund: Int?
}

struct CartContractorDetails: Codable {
    let email: String?
    let firstName: String?
    let id: Int?
    let lastName: String?
}

struct Cart_ItemDetails: Codable {
    let cartId: Int?
    let createdAt: String?
    let id: Int?
    let isDeleted: Int?
    let item: String?
    let price: Double?
    let productId: Int?
    let productsss: ProductsssDetails?
    let quantity: Int?
    let status: Int?
    let updatedAt: String?
}

struct ProductsssDetails: Codable {
    let category: String?
    let id: Int?
    let product_files: [ProductsssDetailsProductFiles]?
}

struct ProductsssDetailsProductFiles: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
}

