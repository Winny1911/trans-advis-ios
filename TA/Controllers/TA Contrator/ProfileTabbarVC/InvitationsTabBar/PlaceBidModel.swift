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
    
    init() {
    }
    
    init(bidAmount: String, amountReceivable: String, startDate: String, endDate: String, description: String, arrOfFilesCount:Int) {
        self.bidAmount = bidAmount
        self.amountReceivable = amountReceivable
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
        self.arrOfFilesCount = arrOfFilesCount
    }
}
