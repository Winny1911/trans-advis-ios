//
//  EVerificationModel.swift
//  TA
//
//  Created by Applify  on 07/01/22.
//

import Foundation

class EVerificationModel {
    var selectedType: String = ""
    
    init() {
    }
    
    init(selectedType: String) {
        self.selectedType = selectedType
    }
}

struct EverificationResponseModel : Codable {
    var message : String?
    var statusCode : Int?
}
