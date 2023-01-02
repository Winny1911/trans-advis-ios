// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ReviewResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: UserModel?
}

// MARK: - DataClass
struct UserModel: Codable {
    //let getUser: GetUser?
    let reviews: [ReviewData]?
    let count: Int?
}

//// MARK: - GetUser
//struct GetUser: Codable {
//    let userType: String?
//    let userFiles: [JSONAny]?
//
//    enum CodingKeys: String, CodingKey {
//        case userType
//        case userFiles = "user_files"
//    }
//}

// MARK: - Review
struct ReviewData: Codable {
    let id, projectID, contractorID, userID: Int?
    let rating: Int?
    let feedback1, feedback2, feedback3, overAllFeedback: String?
    let isDeleted, isBlocked: Int?
    let createdAt, updatedAt: String?
    let ratingImages: [RatingImage]?
    let userDetail: UserDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case contractorID = "contractorId"
        case userID = "userId"
        case rating, feedback1, feedback2, feedback3, overAllFeedback, isDeleted, isBlocked, createdAt, updatedAt
        case ratingImages = "rating_images"
        case userDetail = "user_detail"
    }
}

// MARK: - RatingImage
struct RatingImage: Codable {
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

 //MARK: - UserDetail
struct UserDetails: Codable {
    let id: Int?
    let firstName, lastName: String?
    let profilePic: String?
}
