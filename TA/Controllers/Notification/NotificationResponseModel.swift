//
//  NotificationResponseModel.swift
//  TA
//
//  Created by applify on 02/03/22.
//

import Foundation

// MARK: - NotificationResponseModel
struct NotificationResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: NotificationData?
}

// MARK: - NotificationDataaClass
struct NotificationData: Codable {
    let listing: [NotificationListing]?
    let count, unreadNotificationCount: Int?
}

// MARK: - Listing
struct NotificationListing: Codable {
    let id, senderID, receiverID, platform: Int?
    let notificationType, type: Int?
    let title: String?
    let message: String?
    let objectID, projectID, bidID, subTaskID: Int?
    let ongoingProjectID, isRead, isDeleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "senderId"
        case receiverID = "receiverId"
        case platform, notificationType, type, title, message
        case objectID = "objectId"
        case projectID = "projectId"
        case bidID = "bidId"
        case subTaskID = "subTaskId"
        case ongoingProjectID = "ongoingProjectId"
        case isRead, isDeleted, createdAt, updatedAt
    }
}

enum Title: String, Codable {
    case bid = "Bid"
    case projectAccepted = "Project Accepted"
    case projectCompleted = "Project Completed"
    case taskCompleted = "Task Completed"
}
