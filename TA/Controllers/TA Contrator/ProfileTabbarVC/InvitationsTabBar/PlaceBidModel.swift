//
//  PlaceBidModel.swift
//  TA
//
//  Created by Applify  on 01/01/22.
//

import Foundation
class PlaceBidModel {
    
    var bidAmount: String = ""
    var amountReceivable: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var description: String = ""
    var arrOfFilesCount :Int = 0
    var homeOwnerFirst: String = ""
    var homeOwnerSecond: String = ""
    var streetAddress: String = ""
    var mailingAddress: String = ""
    var cellPhone: String = ""
    var email: String = ""
    var hoa: String = ""
    var permit: String = ""
    var insurance: String = ""
    var claimNeumber: String = ""
    var insFullyApproved: String = ""
    var insPartialApproved: String = ""
    var retail: String = ""
    var RetailWDepreciation: String = ""
    
    init() {
    }
    
    init(bidAmount: String, amountReceivable: String, startDate: String, endDate: String, description: String, arrOfFilesCount:Int, homeOwnerFirst: String, homeOwnerSecond: String, streetAddress: String, mailingAddress: String, cellPhone: String, email: String, hoa: String, permit: String, insurance: String, claimNeumber: String, insFullyApproved: String, insPartialApproved: String, retail: String, retailWDepreciation: String, mainDwellingRoof: String, shedSQ: String, decking: String, flatRoofSQ: String, total: String, deducible: String) {
        self.bidAmount = bidAmount
        self.amountReceivable = amountReceivable
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.arrOfFilesCount = arrOfFilesCount
    }
}
