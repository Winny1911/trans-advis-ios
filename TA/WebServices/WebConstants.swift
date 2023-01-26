//
//  WebConstants.swift
//  Fitsentive
//
//  Created by Applify  on 15/07/21.
//

import Foundation
import UIKit
//https://p2-api.ta123test.com:443

struct APIConstants {
    static let statusCode               = "statusCode"
    static let response                 = "response"
    static let data                     = "data"
    static let message                  = "message"
    static let responseType             = "responseType"
    static let deviceToken              = "1234567890"
}
//https://p2-testapi.ta123test.com
//https://p2-api.ta123test.com
//https://p2-api.ta123test.com:443
//https://p2-testapi.ta123test.com/documentation#!/admins/adminadminslogin_post_10
//http://186.237.229.127:3002
struct GenericErrorMessages {
    static let internalServerError      = "Something went wrong. Try again."
    static let noInternet               = "No internet connection."
}

struct APIUrl {
    // local: https://p2-api.ta123test.com
    // live: http://191.252.93.219:3002
    static let host                   = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String
    static let baseUrlWithOutHttp       = Bundle.main.object(forInfoDictionaryKey: "BASE_URL_WITHOUT_HTTP") as! String
        
    static var baseUrl: String {
        return host + "/api/"
//        return host + "https://p2-testapi.ta123test.com"
    }
    struct UserApis {
        static let register                           = baseUrl              + "user/register"
        static let login                              = baseUrl              + "user/login"
        static let resendEmail                        = baseUrl              + "user/resendEmail"
        static let checkEmailVerfiy                   = baseUrl              + "checkEmailVerfiy"
        static let checkPhoneNumber                   = baseUrl              + "checkPhoneNumber"
        static let fileUpload                         = baseUrl              + "user/fileUpload"
        static let fileUserUpload                     = baseUrl              + "user/upload"
        static let contractorProjectStatus            = baseUrl              + "contractor/projectStatus"

        static let createProfile                      = baseUrl              + "user/createProfile"
        static let createLicense                      = host                 + "user/createLicenses"
        static let updateProfile                      = baseUrl              + "user/updateProfile"
        static let user                               = baseUrl              + "user"
        static let addBankAccount                     = baseUrl              + "contractor/bank/addBankAccount"
        
        static let contractorSendTask                 = baseUrl              + "contractor/sendTask"

        static let getBankAccount                     = baseUrl              + "contractor/bank"
        static let updateBankAccount                  = baseUrl              + "contractor/bank/update"
        
        static let forgotPassword                     = baseUrl              + "user/forgotPassword"
        static let contractor                         = baseUrl              + "homeowner/contractorslist"
        
        static let taskcontractor                         = baseUrl              + "contractor/contractors"

        static let contractorslist                    = baseUrl              + "homeowner/contractorslist"
        static let contractorsForBid                  = baseUrl              + "contractor/contractors"
        static let getReview                          = baseUrl              + "getReviews"
//        static let ratingImages                       = baseUrl              +  "contractor/RatingImages"
        static let projectFileUpload                  = baseUrl              + "homeowner/fileUpload"
        static let updateProjectImagesFiles           = baseUrl              + "homeowner/updateProjectImagesFiles"

        static let projectCategoriesList              = host                 + "/admin/content-management/projectCategories/list"
        
        static let createProject                      = baseUrl              + "homeowner/createProject"
        static let contractorCarts                    = baseUrl              + "contractor/carts"
        static let contractorUpdateCartStatus         = baseUrl              + "contractor/updateCartStatus"
        static let fetchDisputeReasons                = baseUrl              + "contractor/dispute/reason"
        static let submitDispute                      = baseUrl              + "dispute/create"

        static let updateProject                      = baseUrl              + "homeowner/updateProject"
        static let deleteProjectFile                  = baseUrl              + "homeowner/deleteProjectFile"
        static let deleteBidFile                      = baseUrl              + "contractor/deleteFile"

        static let updateProjectFile                  = baseUrl              + "homeowner/updateProjectFile"

        static let projectListHO                      = baseUrl              + "homeowner/getAllProjects"
        
        static let projectListDetailsHO                      = baseUrl              + "homeowner/homeOwnerPastProjectsById"
        static let projectDelete                      = baseUrl              + "homeowner/deleteProject"
        static let projectOngoingListHO               = baseUrl              + "homeowner/ongoingProjects"
        
        static let projectOngoingDetailsListHO        = baseUrl              + "homeowner/ongoingProjectsById"
        
        static let getProjectDetailsById              = baseUrl              + "homeowner/getProjectDetailsById"
        static let sendProject                        = baseUrl              + "homeowner/sendProjects"
      
        static let filterHO                           = baseUrl              +  "homeowner/contractorFiltersV2"
        static let filteCOInviteBids                  = baseUrl              +  "contractor/contractorFiltersV2"

        static let contractorInvitations              = baseUrl              + "contractor/invitations"
        static let contractorOngoingProjects          = baseUrl              + "contractor/ongoingProjects"
        static let contratorPastProjects              = baseUrl              + "contractor/pastProjects"
        
        static let contratorArchiveProjects           = baseUrl              + "contractor/archievedProjects"
        static let contractorOngoingProjectsById      = baseUrl              + "contractor/ongoingProjectsById"
        static let contractorOngoingtaskList          = baseUrl              + "contractor/taskList"

        static let contractorDeleteTask               = baseUrl              + "contractor/deleteTask"

        static let contractorBidDetailsById           = baseUrl              + "contractor/BidDetailsById"
        static let contractorRecallBid                = baseUrl              + "contractor/recallBid"
        static let contractorBidLog                   = baseUrl              + "contractor/bidLog"
        static let agreementGenerate                  = baseUrl              + "agreement/generate"

        static let contractorManageBids               = baseUrl              + "contractor/bids"
        static let contractorinvitationFilters        = baseUrl              + "contractor/invitationFilters"
        static let contractorProjectFilters           = baseUrl              + "contractor/projectFilters"

        static let contractorFileUpload               = baseUrl              + "contractor/fileUpload"
        static let postContractorBid                  = baseUrl              + "contractor/bids"
        static let postContractorTasks                = baseUrl              + "contractor/tasks"
        static let vendorProfileCO                = baseUrl              + "contractor/vendor/:id"

        static let projectAgreement                   = baseUrl              + "Project/Agreement"
        
        static let profileHO                          = baseUrl              + "user"
        static let AccountDelete                      = baseUrl              + "user/"
        static let editProfile                        = baseUrl              + "user/updateProfile"
        static let changePassword                     = baseUrl              + "user/changePassword"
        static let viewBids                           = baseUrl              + "homeowner/bids"
        static let bidDetail                          = baseUrl              + "homeowner/BidDetailsById"

        static let logout                             = baseUrl              +  "user/logout"
        static let approveDelivery                    =  baseUrl             +  "homeowner/acceptOrRejectDelivery"
        static let transactionHistory                 =  baseUrl             +  "homeowner/TransactionHistory"
        static let userBankDetails                    = baseUrl              + "contractor/bank/getAllbank"
        static let ratingImages                       = baseUrl              +  "contractor/RatingImages"
        static let portfolioImageUpload               = baseUrl              +  "user/fileUpload"
        static let uploadPortfolioImage               = baseUrl              +  "contractor/PortFolioImages"
        
//        static let approveDelivery                  = baseUrl             +  "homeowner/acceptOrRejectDelivery"
//        static let transactionHistory               = baseUrl             +  "homeowner/TransactionHistory"
        static let transactionHistoryCO               = baseUrl             +  "contractor/TransactionHistory"
        static let transactionHistorySubTaskCO        = baseUrl             +  "contractor/subTaskTransactionHistoryCart"
        static let rejectOrAcceptBid                  = baseUrl             +  "homeowner/acceptOrRejectBid"
        static let agreementDocument                  = baseUrl             +  "Project/agreementDocument?"
        static let agreementTaskDocument              = baseUrl             +  "Project/subtaskAgreementDocument?"
        static let inviteBidsToContractor             = baseUrl             +  "contractor/subtask"
        static let MaterialCO                         = baseUrl             +   "vendor/products"

        
        static let pastProjectDetail                  = baseUrl             +   "contractor/pastProjectsById"
        
        static let pastProjectOrderList               = baseUrl             +   "contractor/carts"
        
        static let pastProjectTaskCO                  = baseUrl             +   "contractor/taskList"

        static let contractorSubTaskById              = baseUrl             +   "contractor/subTaskById"
        static let contractorSubcontractorSubTaskById = baseUrl             +   "contractor/subcontractor/subTaskById"
        static let contractorTasksBids                = baseUrl             +   "contractor/tasks/bids"
        static let contractorRejectOrAcceptBid        = baseUrl             +  "contractor/acceptOrRejectBid"
        static let taskMarkCompleted                  = baseUrl             +  "contractor/markTaskComplete"

        static let contractorVendorProducts           = baseUrl             +  "contractor/vendor/products"
        static let contractorCartsCreate              = baseUrl             +  "contractor/carts/create"
        
        static let feedBackCO                         = baseUrl             +  "contractor/rating"
        static let notificationHO                     = baseUrl               + "users/notifications"
        static let feedBackHO                         = baseUrl                + "homeowner/rating"
        static let helpAndSupport                     = baseUrl                + "generalSettings"
        static let chatHistoryAPI                     = baseUrl             + "chathistory"
        static let verifyEmail                        = baseUrl                + "user/resendEmail"
        static let versionControl                     = baseUrl             + "version"
        static let saveAgreements                     = baseUrl             + "agreement/generate"
        static let cardDetails                        = baseUrl             + "contractor/cartDetail"
        static let subTaskAgreement                   = baseUrl             + "agreement/subtaskAgrement"
    }
}
