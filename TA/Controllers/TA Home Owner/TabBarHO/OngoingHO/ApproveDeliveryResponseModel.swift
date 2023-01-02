//
//  ApproveDeliveryResponseModel.swift
//  TA
//
//  Created by Applify on 10/01/22.
//

import Foundation

// MARK: - ApproveDeliveryResponseModel
struct ApproveDeliveryResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: DeliveryData
}

// MARK: - DataClass
struct DeliveryData: Codable {
    let statusCode: Int
    let customMessage, type: String
}

