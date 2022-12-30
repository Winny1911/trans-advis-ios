//
//  DeleteAccountModel.swift
//  TA
//
//  Created by iOS on 11/10/22.
//

import Foundation

// MARK: - DeleteAccountModel
struct DeleteAccountModel: Codable {
    let statusCode: Int?
    let error, message, responseType: String?
}
