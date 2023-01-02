//
//  SendProjectModel.swift
//  TA
//
//  Created by Dev on 23/12/21.
//

import Foundation

// MARK: - SentProjectModel
struct SentProjectModel: Codable {
    let statusCode: Int
    let message: String
    let data: SentProject
}

// MARK: - DataClass
struct SentProject: Codable {
    let statusCode: Int
    let customMessage, type: String
}

