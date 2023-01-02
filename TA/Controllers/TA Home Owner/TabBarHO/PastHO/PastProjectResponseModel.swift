//
//  PastProjectResponseModel.swift
//  TA
//
//  Created by applify on 27/02/22.
//



import Foundation

// MARK: - Welcome
struct PastProjectResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: PastProjects?
}

// MARK: - DataClass
struct PastProjects: Codable {
    let allProjects: [AllPastProject]?
}

// MARK: - AllProject
struct AllPastProject: Codable {
    let id: Int?
    let title, allProjectDescription: String?
    let status: Int?
    let type, amountCurrency: String?
    let price: Int?
    let country, state, city, addressLine1: String?
//    let addressLine2: JSONNull?
    let zipCode: String?
    let userID, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
    let isAdminPermission: Int?
    let projectFiles: [PastProjectFile]?
//    let contractorRating, homeownerRating: JSONNull?
    let projectDeliverable: [PastProjectDeliverable]?
    let bids: [PastBid]?
    let tasks, mainProjectTasks: [PastTask]?
    let contractorProject: [PastContractorProject]?
    let projectAgreement: [PastProjectAgreement]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case allProjectDescription = "description"
        case status, type, amountCurrency, price, country, state, city, addressLine1, zipCode
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt, isAdminPermission
        case projectFiles = "project_files"
//        case contractorRating = "contractor_rating"
//        case homeownerRating = "homeowner_rating"
        case projectDeliverable = "project_deliverable"
        case bids, tasks, mainProjectTasks
        case contractorProject = "contractor_project"
        case projectAgreement = "project_agreement"
    }
}

// MARK: - Bid
struct PastBid: Codable {
    let id, userID, projectID: Int?
    let amountCurrency, bidAmount, amountRecievable, bidDescription: String?
    let proposedStartDate, proposedEndDate: String?
    let bidStatus, isDeleted: Int?
    let createdAt, updatedAt: String?
    let bidsDocuments: [PastProjectFile]?
    let user: PastUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case projectID = "projectId"
        case amountCurrency, bidAmount, amountRecievable
        case bidDescription = "description"
        case proposedStartDate, proposedEndDate, bidStatus, isDeleted, createdAt, updatedAt
        case bidsDocuments = "bids_documents"
        case user
    }
}

// MARK: - ProjectFile
struct PastProjectFile: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
    let userID: String?
    let userDetail: PastUserDetail?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type, isDeleted, createdAt, updatedAt
        case userID = "userId"
        case userDetail = "user_detail"
    }
}

// MARK: - UserDetail
struct PastUserDetail: Codable {
    let firstName, lastName: String?
}

// MARK: - User
struct PastUser: Codable {
    let id: Int?
    let firstName, lastname: String?
    let profilePic: String?
}

// MARK: - ContractorProject
struct PastContractorProject: Codable {
    let id, userID, projectStatus: Int?
    let contractorDetails: PastContractorDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case projectStatus
        case contractorDetails = "contractor_details"
    }
}

// MARK: - ContractorDetails
struct PastContractorDetails: Codable {
    let id: Int?
    let firstName, lastName, email: String?
    let isBlocked, emailVerified: Int?
    let zipCode, addressLine1, addressLine2, state: String?
    let city, country, phoneNumber: String?
    let profilePic: String?
    let accessToken, skillSet, rating: String?
    let completedProjectCount: Int?
    let userFiles, ratings: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, isBlocked, emailVerified, zipCode, addressLine1, addressLine2, state, city, country, phoneNumber, profilePic, accessToken, skillSet, rating, completedProjectCount
        case userFiles = "user_files"
        case ratings
    }
}

// MARK: - Task
struct PastTask: Codable {
    let id: Int?
    let task: String?
    let userID, status, projectID, isDeleted: Int?
    let isBlocked: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, task
        case userID = "userId"
        case status
        case projectID = "projectId"
        case isDeleted, isBlocked, createdAt, updatedAt
    }
}

// MARK: - ProjectAgreement
struct PastProjectAgreement: Codable {
    let id, projectID, userID: Int?
    let title: String?
    let file: String?
    let type, userType: String?
    let isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case userID = "userId"
        case title, file, type, userType, isBlocked, isDeleted, createdAt, updatedAt
    }
}

// MARK: - ProjectDeliverable
struct PastProjectDeliverable: Codable {
    let id: Int?
    let deliveralble: String?
    let deliveralbleOrder, userID: Int?

    enum CodingKeys: String, CodingKey {
        case id, deliveralble, deliveralbleOrder
        case userID = "userId"
    }
}

//// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

