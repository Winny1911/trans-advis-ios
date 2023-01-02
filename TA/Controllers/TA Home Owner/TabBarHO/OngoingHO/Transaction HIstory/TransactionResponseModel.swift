//
//  TransactionResponseModel.swift
//  TA
//
//  Created by Applify on 11/01/22.
//

import Foundation

import Foundation

// MARK: - TransactionResponseModel
struct TransactionResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: TransactionData?
}

// MARK: - DataClass
struct TransactionData: Codable {
    let id: Int?
    let title, dataDescription: String?
    let status: Int?
    let type, amountCurrency: String?
    let price, userID, finalPrice, spent: Int?
    let totalSpent: Int?
    let bidAmount: String?
    let bidFloatAmount, available, estimatedPrfitLoss: Int?
    let bids: [BidsDetails]?
    let tasks: [TasksDetailss]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case dataDescription = "description"
        case status, type, amountCurrency, price
        case userID = "userId"
        case finalPrice, spent
        case totalSpent = "TotalSpent"
        case bidAmount, bidFloatAmount
        case available = "Available"
        case estimatedPrfitLoss = "EstimatedPrfitLoss"
        case bids
        case tasks = "Tasks"
    }
}

// MARK: - Bid
struct BidsDetails: Codable {
    let id, userID, projectID: Int?
    let amountCurrency, bidAmount, amountRecievable, bidDescription: String?
    let bidStatus: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case projectID = "projectId"
        case amountCurrency, bidAmount, amountRecievable
        case bidDescription = "description"
        case bidStatus
    }
}

// MARK: - Task
struct TasksDetailss: Codable {
    let id, userID, projectID: Int?
    let type, task: String?
    var status, budget,taskType: Int?
    let createdAt: String?
    let paymentStatus: Int?
    
    var assginee: Assginee?

    enum CodingKeys: String, CodingKey {
        case paymentStatus
        case id
        case taskType
        case userID = "userId"
        case projectID = "projectId"
        case type, task, status, budget, createdAt
        case assginee = "Assginee"
    }
}

// MARK: - Assginee
struct Assginee: Codable {
    let id: Int?
    var firstName, lastName, email: String?
}

