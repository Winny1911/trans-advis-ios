//
//  EVerificationHOModel.swift
//  TA
//
//  Created by Applify  on 18/01/22.
//

import Foundation

class EVerificationHOModel {
    var selectedType: String = ""
    
    init() {
    }
    
    init(selectedType: String) {
        self.selectedType = selectedType
    }
}

struct EverificationHOResponseModel : Codable {
    var message : String?
    var statusCode : Int?
}
