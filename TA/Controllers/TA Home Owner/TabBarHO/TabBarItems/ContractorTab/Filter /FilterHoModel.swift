//
//  FilterHoModel.swift
//  TA
//
//  Created by Designer on 21/12/21.
//

import Foundation

// MARK: - FilterHoModel
struct FilterHoModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: FilterData?
}

// MARK: - DataClass
struct FilterData: Codable {
    let location: [String]?
    let work: [WorkDetails]?
}

struct WorkDetails: Codable {
    let id: Int?
    let projectCategory: Project_details?
    let projectCategoriesId: Int?
}

struct Project_details: Codable {
    let id: Int?
    let projectCategoriesId: Int?
    let projectCategory: ProjectCategory? //ProjectCategoryDetails?
    let title: String?
}

struct ProjectCategory: Codable {
    let id: Int?
    let title: String?
}

struct ProjectCategoryDetails: Codable {
    let id: Int?
    let title: String?
}

struct FilterCOModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: FilterCOData?
}

// MARK: - DataClass
struct FilterCOData: Codable {
    let location: [String]?
    let work: [COWorkDetails]?
}

struct COWorkDetails: Codable {
    let id: Int?
    let name: String?
    let projectCategory: ProjectCategoryDetails?
    let skillId: Int?
    let userId: Int?
}


import Foundation

// MARK: - EatingTypeModel
struct HoFilterResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: HoFilterData?
}

// MARK: - DataClass
struct HoFilterData: Codable {
    let work: [Worksss]?
    let location: [String]?
}

// MARK: - Work
struct Worksss: Codable {
    let id, projectCategoriesID: Int?
    let projectCategory: ProjectCategorysss?

    enum CodingKeys: String, CodingKey {
        case id
        case projectCategoriesID = "projectCategoriesId"
        case projectCategory
    }
}

// MARK: - ProjectCategory
struct ProjectCategorysss: Codable {
    let id: Int?
    let title: String?
}
