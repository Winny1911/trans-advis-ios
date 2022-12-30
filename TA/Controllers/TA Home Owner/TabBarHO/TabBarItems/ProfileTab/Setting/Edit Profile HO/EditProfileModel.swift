//
//  EditProfileModel.swift
//  TA
//
//  Created by Designer on 03/01/22.
//

import Foundation

// MARK: - EditProfile
struct EditProfileModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: EditData?
}

// MARK: - DataClass
struct EditData: Codable {
    let statusCode: Int?
    let customMessage, type: String?
}
