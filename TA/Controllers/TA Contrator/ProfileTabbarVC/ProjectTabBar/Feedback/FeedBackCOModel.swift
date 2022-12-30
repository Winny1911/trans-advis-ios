//
//  FeedBackCOModel.swift
//  TA
//
//  Created by Applify on 28/02/22.
//

import Foundation

import Foundation

// MARK: - Welcome
struct FeedBackCOModel: Codable {
    let statusCode: Int
    let message: String
    let data: FeedBackDataCo
}

// MARK: - DataClass
struct FeedBackDataCo: Codable {
    let statusCode: Int
    let customMessage, type: String
}

