//
//  AppVersionResponseModel.swift
//  TA
//
//  Created by Applify on 27/07/22.
//

import Foundation

struct AppVersionResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : AppVersionData?
}

struct AppVersionData: Codable {
    var success: Int? = 0
    var force_update: Int? = 0
    var new_update: Int? = 0
}
