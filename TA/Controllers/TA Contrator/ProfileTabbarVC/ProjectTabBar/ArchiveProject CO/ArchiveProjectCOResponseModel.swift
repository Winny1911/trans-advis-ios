//
//  ArchiveProjectCOResponseModel.swift
//  TA
//
//  Created by Applify on 03/02/22.
//

import Foundation

// MARK: - ArchiveProjectCOResponseModel
struct ArchiveProjectCOResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: ArchiveProjectData?
}

// MARK: - DataClass
struct ArchiveProjectData: Codable {
    let allProjects: [ArchiveProjectAllProjectDetail]?
    let count: Int?
}

// MARK: - AllProject
struct ArchiveProjectAllProjectDetail: Codable {
    let id: Int?
    let createdAt: String?
    let projectID: Int?
    let updatedAt, project, progress: String?
    let projectDetails: ArchiveProjectDetails?

    enum CodingKeys: String, CodingKey {
        case id, createdAt
        case projectID = "projectId"
        case updatedAt, project, progress
        case projectDetails = "project_details"
    }
}

// MARK: - ProjectDetails
struct ArchiveProjectDetails: Codable {
    let id: Int?
    let title, projectDetailsDescription: String?
    let projectType: Int?
    let type, amountCurrency: String?
    let price: Int?
    let country, state, city, addressLine1: String?
//    let addressLine2: JSONNull?
    let zipCode: String?
    let userID, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
    let status: Int?
    let userData: ArchiveCOUserData?
    let projectFiles: [ArchiveProjectFile]?
    let bids: [ArchiveBid]?
    let homeownerRating, contractorRating: ArchiveRRating?
//    let tasks: [JSONAny]
    let progress : String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case projectDetailsDescription = "description"
        case projectType, type, amountCurrency, price, country, state, city, addressLine1, zipCode //addressLine2
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt, status
        case userData = "user_data"
        case projectFiles = "project_files"
        case bids
        case homeownerRating = "homeowner_rating"
        case contractorRating = "contractor_rating"
        case progress
//        case tasks
    }
}

// MARK: - Bid
struct ArchiveBid: Codable {
    let id, userID, projectID: Int?
    let amountCurrency, bidAmount, amountRecievable, bidDescription: String?
    let proposedStartDate, proposedEndDate: String?
    let bidStatus, isDeleted: Int?
    let createdAt, updatedAt: String?
    let contractorssss: ArchiveContractorssss?
    let bidsDocuments: [ArchiveProjectFile]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case projectID = "projectId"
        case amountCurrency, bidAmount, amountRecievable
        case bidDescription = "description"
        case proposedStartDate, proposedEndDate, bidStatus, isDeleted, createdAt, updatedAt, contractorssss
        case bidsDocuments = "bids_documents"
    }
}

// MARK: - ProjectFile
struct ArchiveProjectFile: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type, isDeleted, createdAt, updatedAt
        case userID = "userId"
    }
}

// MARK: - Contractorssss
struct ArchiveContractorssss: Codable {
    let id: Int
    let firstName, lastName, createdAt, email: String
    let phoneNumber: String
}

// MARK: - RRating
struct ArchiveRRating: Codable {
    let id, projectID: Int?
    let contractorID: Int?
    let userID, rating: Int?
    let feedback1, feedback2, feedback3, overAllFeedback: String?
    let isDeleted, isBlocked: Int?
    let createdAt, updatedAt: String?
    let ratingImages: [ArchiveRatingImage]?
    let homeownerID: Int?
//    let homeOwnerRatingImages: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case contractorID = "contractorId"
        case userID = "userId"
        case rating, feedback1, feedback2, feedback3, overAllFeedback, isDeleted, isBlocked, createdAt, updatedAt
        case ratingImages = "rating_images"
        case homeownerID = "homeownerId"
//        case homeOwnerRatingImages = "HomeOwnerRatingImages"
    }
}

// MARK: - RatingImage
struct ArchiveRatingImage: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let projectID, userID, ratingID, isBlocked: Int?
    let isDeleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type
        case projectID = "projectId"
        case userID = "userId"
        case ratingID = "ratingId"
        case isBlocked, isDeleted, createdAt, updatedAt
    }
}

// MARK: - UserData
struct ArchiveCOUserData: Codable {
    let id: Int?
    let firstName, lastName, profilePic: String
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
//
//class JSONCodingKey: CodingKey {
//    let key: String
//
//    required init?(intValue: Int) {
//        return nil
//    }
//
//    required init?(stringValue: String) {
//        key = stringValue
//    }
//
//    var intValue: Int? {
//        return nil
//    }
//
//    var stringValue: String {
//        return key
//    }
//}
//
//class JSONAny: Codable {
//
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}

