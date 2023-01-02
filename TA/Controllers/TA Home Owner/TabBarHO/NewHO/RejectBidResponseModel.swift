//
//  RejectBidResponseModel.swift
//  TA
//
//  Created by applify on 11/01/22.
//

import Foundation
// MARK: - Welcome
struct RejectBidResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: RejectBidModel
}

// MARK: - DataClass
struct RejectBidModel: Codable {
    let statusCode: Int
    let customMessage, type: String
}
