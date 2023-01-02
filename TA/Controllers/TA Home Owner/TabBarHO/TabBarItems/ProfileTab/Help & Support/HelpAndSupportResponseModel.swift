//
//  HelpAndSupportResponseModel.swift
//  TA
//
//  Created by applify on 08/03/22.
//



import Foundation

// MARK: - Welcome
struct HelpAndSupportResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: HelpAndResponseData
}

// MARK: - DataClass
struct HelpAndResponseData: Codable {
    let id: Int?
    let supportURL, privacyPolicyURL: String?
    let supportEmail, supportNumber, contactText, feedbackEmail: String?
    let faqURL: String?
    let createdAt, updatedAt: String?
    let termsOfServices: String

    enum CodingKeys: String, CodingKey {
        case id
        case supportURL = "supportUrl"
        case privacyPolicyURL = "privacyPolicyUrl"
        case termsOfServices = "termsOfServices"
        case supportEmail, supportNumber, contactText, feedbackEmail
       // case helpURL = "helpUrl"
        case faqURL = "faqUrl"
        case createdAt, updatedAt
    }
}

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
