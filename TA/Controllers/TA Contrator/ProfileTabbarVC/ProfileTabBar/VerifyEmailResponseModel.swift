//
//  VerifyEmailResponseModel.swift
//  TA
//
//  Created by Dev on 15/03/22.
//

import Foundation

// MARK: - Welcome
struct VerifyEmailResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: EmailData?
}

// MARK: - DataClass
struct EmailData: Codable {
    let statusCode: Int?
    let customMessage, type: String?
}
