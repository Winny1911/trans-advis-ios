//
//  PortfolioImageUploadModel.swift
//  TA
//
//  Created by Applify on 18/01/22.
//

import Foundation

// MARK: - PortfolioImageUploadModel
struct PortfolioImageUploadModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: PortFolioImageUpload?
}

// MARK: - DataClass
struct PortFolioImageUpload: Codable {
    let name, dataExtension: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case name
        case dataExtension = "extension"
        case url
    }
}
