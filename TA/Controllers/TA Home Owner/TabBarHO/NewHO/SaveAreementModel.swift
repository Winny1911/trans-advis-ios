//
//  SaveAreementModel.swift
//  TA
//
//  Created by iOS on 03/10/22.
//

import Foundation

import Foundation

// MARK: - SaveAgreementModel
struct SaveAgreementModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: SaveAgreementData?
}

// MARK: - DataClass
struct SaveAgreementData: Codable {
    let web, app: App?
}

// MARK: - App
struct App: Codable {
    let filename, appExtension: String?
    let downloadURL: String?

    enum CodingKeys: String, CodingKey {
        case filename
        case appExtension = "extension"
        case downloadURL = "downloadUrl"
    }
}
