//
//  FeedbackHOResponseModel.swift
//  TA
//
//  Created by applify on 04/03/22.
//


import Foundation

// MARK: - Welcome
struct FeedbackHOResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: FeedBackData?
}

// MARK: - DataClass
struct FeedBackData: Codable {
    let statusCode: Int?
    let customMessage, type: String?
}
