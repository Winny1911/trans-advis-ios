//
//  MaterialCOResponseModel.swift
//  TA
//
//  Created by Applify on 31/01/22.
//

import Foundation

// MARK: - MaterialCOResponseModel

struct MaterialVendorCOResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: MaterialVendorCOData?
}

struct MaterialVendorCOData: Codable {
    let listing: [MaterialDetailCOData]?
    let count: Int?
}

struct MaterialCOResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: MaterialCOData?
}

// MARK: - DataClass
struct MaterialCOData: Codable {
    let allProducts: [MaterialDetailCOData]?
    let count: Int?
    let filter: Filter?
    let venderDeepLink, contractorDeepLink: String?
}

// MARK: - AllProduct
struct MaterialDetailCOData: Codable {
    let id: Int?
    let name, allProductDescription, size, amountCurrency: String?
    let price: Double?
    let weight, brand, category, subCategory: String?
    let material: String?
    let userID, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
    let productFiles: [ProductFile]?
    let user: MaterialCOUser?
    var isSelected : Bool?

    enum CodingKeys: String, CodingKey {
        case id, name
        case allProductDescription = "description"
        case size, amountCurrency, price, weight, brand, category, subCategory, material
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt
        case productFiles = "product_files"
        case user
    }
}

// MARK: - ProductFile
struct ProductFile: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
}

// MARK: - User
struct MaterialCOUser: Codable {
    let id: Int?
    let firstName, lastName, email: String?
}

// MARK: - Filter
struct Filter: Codable {
    let states, firstName: [String]?
    let category: [CategoryDtls]?
}

struct CategoryDtls: Codable {
    let id: Int?
    let title: String?
}
