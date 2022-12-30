//
//  FilterResponseModel.swift
//  TA
//
//  Created by Applify  on 21/12/21.
//

import Foundation

struct FilterResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : FilterResponseModelDetail?
}

struct FilterResponseModelDetail : Codable {
    var skills : [WorkDetailss]?
    var states : [String]?
    var progress : [String]?
}

struct WorkDetailss: Codable {
    let id: Int?
    let title: String?
}

struct FilterOngoingResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : FilterOngoingResponseModelDetail?
}

struct FilterOngoingResponseModelDetail : Codable {
    var listing : FilterOngoingListing?
    
}
struct FilterOngoingListing : Codable {
    var location : [String]?
    var status : [String]?
    let work: [WorkDetailss]?
}
