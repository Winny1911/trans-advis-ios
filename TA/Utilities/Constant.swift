//
//  Constant.swift
//  TA
//
//  Created by Avninder Singh on 09/12/21.
//

import Foundation
import UIKit

let isDebugingMode = Bundle.main.object(forInfoDictionaryKey: "IsProduction") as! String

struct UserType {
    static let homeOwner = "HO"
    static let contractor = "CO"
}

struct PoppinsFont {
    static let regular = "Poppins-Regular"
    static let semiBold = "Poppins-SemiBold"
    static let medium = "Poppins-Medium"
}

struct Storyboard {
    static let login = UIStoryboard(name: "Login", bundle: Bundle.main)
    static let signUp = UIStoryboard(name: "SignUp", bundle: Bundle.main)
    static let forgotPassword = UIStoryboard(name: "ForgetPassword", bundle: Bundle.main)
    static let createAccountTAC = UIStoryboard(name: "CreateAccountTAC", bundle: Bundle.main)
    static let tabBarHO  = UIStoryboard(name: "TabBarHO", bundle: Bundle.main)
    static let projectHO  = UIStoryboard(name: "ProjectHO", bundle: Bundle.main)
    static let contractorHO  = UIStoryboard(name: "ContractorHO", bundle: Bundle.main)
    static let messageHO  = UIStoryboard(name: "MessageHO", bundle: Bundle.main)
    static let profileHO  = UIStoryboard(name: "ProfileHO", bundle: Bundle.main)
    static let newHO  = UIStoryboard(name: "NewHO", bundle: Bundle.main)
    static let ongoingHO  = UIStoryboard(name: "OngoingHO", bundle: Bundle.main)
    static let pastHO  = UIStoryboard(name: "PastHO", bundle: Bundle.main)
    static let archiveHO  = UIStoryboard(name: "ArchiveHO", bundle: Bundle.main)
    static let createProjectHO  = UIStoryboard(name: "CreateProjectHO", bundle: Bundle.main)
   // static let contractorProfiletHO  = UIStoryboard(name: "ContractorHO", bundle: Bundle.main)
    static let feedback =  UIStoryboard(name: "FeedBack", bundle: Bundle.main)
    static let ongoingDetailHO =  UIStoryboard(name: "OngoingDetailHO", bundle: Bundle.main)
    static let mainProjectHo =  UIStoryboard(name: "MainProjectHO", bundle: Bundle.main)
    static let taskHO =  UIStoryboard(name: "TaskHO", bundle: Bundle.main)
    
    static let orderMaterial  = UIStoryboard(name: "OrderMaterial", bundle: Bundle.main)
   
  


    static let tabBar = UIStoryboard(name: "ContratorTabBar", bundle: Bundle.main)
    static let project = UIStoryboard(name: "Project", bundle: Bundle.main)
    
    static let material = UIStoryboard(name: "Material", bundle: Bundle.main)
    static let invitation = UIStoryboard(name: "Invitation", bundle: Bundle.main)
    static let message = UIStoryboard(name: "Message", bundle: Bundle.main)
    static let profile = UIStoryboard(name: "Profile", bundle: Bundle.main)
    
    static let onGoingProfile = UIStoryboard(name: "Ongoing", bundle: Bundle.main)
    static let pastProject = UIStoryboard(name: "PastProject", bundle: Bundle.main)
    static let archiveProfile = UIStoryboard(name: "ArchiveProfile", bundle: Bundle.main)
    
    static let mainProjectTask = UIStoryboard(name: "MainProjectTask", bundle: Bundle.main)
    static let mainProject = UIStoryboard(name: "MainProject", bundle: Bundle.main)
    static let tasks = UIStoryboard(name: "Tasks", bundle: Bundle.main)
    static let orderlist = UIStoryboard(name: "Orderlist", bundle: Bundle.main)
    
    static let subTaskProject = UIStoryboard(name: "SubTaskProject", bundle: Bundle.main)
    static let subTask = UIStoryboard(name: "SubTask", bundle: Bundle.main)
    static let subTaskOrderList = UIStoryboard(name: "SubTaskOrderList", bundle: Bundle.main)
    
    static let pastMainProjectTask = UIStoryboard(name: "PastMainProjectTask", bundle: Bundle.main)
    static let pastMainProject = UIStoryboard(name: "PastMainProject", bundle: Bundle.main)
    static let pastTasks = UIStoryboard(name: "PastTasks", bundle: Bundle.main)
    static let pastOrderlist = UIStoryboard(name: "PastOrderlist", bundle: Bundle.main)
    
    static let pastSubTaskProject = UIStoryboard(name: "PastSubTaskProject", bundle: Bundle.main)
    static let pastSubTask = UIStoryboard(name: "PastSubTask", bundle: Bundle.main)
    static let pastSubOrderList = UIStoryboard(name: "PastSubOrderList", bundle: Bundle.main)
    
    static let archiveMainProjectTask = UIStoryboard(name: "ArchiveProjectTask", bundle: Bundle.main)
    static let archiveMainProject = UIStoryboard(name: "ArchiveMainProject", bundle: Bundle.main)
    static let archiveTasks = UIStoryboard(name: "ArchiveTask", bundle: Bundle.main)
    static let archiveOrderlist = UIStoryboard(name: "ArchiveOrderlist", bundle: Bundle.main)
    
    static let archiveProjectCOMainTask = UIStoryboard(name: "ArchiveProjectCOMainTask", bundle: Bundle.main)
    
    static let archiveProjectSubTaskCOVC = UIStoryboard(name: "ArchiveProjectSubTaskCO", bundle: Bundle.main)
    
    static let pastProjectSubTaskCO = UIStoryboard(name: "PastProjectSubTaskCO", bundle: Bundle.main)
  
   // static let notificationHO = UIStoryboard(name: "ProjectHO", bundle: Bundle.main)
    static let feedBackHO = UIStoryboard(name: "FeedBackHO", bundle: Bundle.main)

}

struct Controllers {
    
    static let loginVC = Storyboard.login.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
    static let signUp = Storyboard.signUp.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
    static let verifyEmail = Storyboard.signUp.instantiateViewController(withIdentifier: "VerifyVC") as? VerifyVC
    static let forgotPassword = Storyboard.forgotPassword.instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC
    static let resetRequest = Storyboard.forgotPassword.instantiateViewController(withIdentifier: "ResetRequestVC") as? ResetRequestVC
    
    static let createAccountTAC = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "CreateAccountTAC") as? CreateAccountTAC
    static let createAccountTACUploadLicense = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "UploadLicenceVC") as? UploadLicenceVC
    static let createAccountTACLocation = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "SetLocationVC") as? SetLocationVC
    static let createAccountTACAccount = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "AddBankAccountVC") as? AddBankAccountVC
    static let awaitingApproval = Storyboard.createAccountTAC.instantiateViewController(withIdentifier: "AwaitingApprovalVC") as? AwaitingApprovalVC
    
    static let tabBarHO = Storyboard.tabBarHO.instantiateViewController(withIdentifier: "TabBarHOVC") as? TabBarHOVC
    static let projectHO = Storyboard.projectHO.instantiateViewController(withIdentifier: "ProjectHOVC") as? ProjectHOVC
    static let contractorHO = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorHOVC") as? ContractorHOVC
//    static let filterScreenHO = Storyboard.contractorHO.instantiateViewController(withIdentifier: "FilterScreenHOVC") as? FilterScreenHOVC
    static let contractorFilterHO = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorFilterVC") as? ContractorFilterVC
    static let messageHO = Storyboard.contractorHO.instantiateViewController(withIdentifier: "MessageHOVC") as? MessageHOVC
    static let profileHO = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ProfileHOVC") as? ProfileHOVC
    static let settingHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "SettingHOVC") as? SettingHOVC
    static let addPortfolioImage = Storyboard.profile.instantiateViewController(withIdentifier: "AddPortfolioImageVC") as? AddPortfolioImageVC
    static let LogoutHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "LogoutVC") as? LogoutVC
    static let changePasswordHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "ChangePasswordVC") as? ChangePasswordVC
    
    static let EditProfleHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "EditProfleHO") as? EditProfleHO
    static let newHO = Storyboard.newHO.instantiateViewController(withIdentifier: "NewHOVC") as? NewHOVC
    static let newDetailHO = Storyboard.newHO.instantiateViewController(withIdentifier: "NewDetailsHOVC") as? NewDetailsHOVC
    static let editAndDeleteHO = Storyboard.newHO.instantiateViewController(withIdentifier: "EditAndDeleteVC") as? EditAndDeleteVC
    static let ongoingHO = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "OngoingHOVC") as? OngoingHOVC
    static let TransactionHistory = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionHistoryVC") as? TransactionHistoryVC
    static let transactionPopUpView = Storyboard.ongoingHO.instantiateViewController(withIdentifier: "TransactionPopUpViewVC") as? TransactionPopUpViewVC
    static let pastHO = Storyboard.pastHO.instantiateViewController(withIdentifier: "PastHOVC") as? PastHOVC
    static let archiveHO = Storyboard.archiveHO.instantiateViewController(withIdentifier: "ArchiveHOVC") as? ArchiveHOVC
    static let createProjectHO = Storyboard.createProjectHO.instantiateViewController(withIdentifier: "CreateProjectHOVC") as? CreateProjectHOVC
    static let contractorProfilestHO = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorProfileHOVC") as? ContractorProfileHOVC
    static let sendProjectHO = Storyboard.contractorHO.instantiateViewController(withIdentifier: "SelectProjectToSendHOVC") as? SelectProjectToSendHOVC
    static let ongoingDetailHO = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "OngoingDetailHOVC") as? OngoingDetailHOVC
    static let mainProjectHO = Storyboard.mainProjectHo.instantiateViewController(withIdentifier: "MainProjectHOVC") as? MainProjectHOVC
    static let taskHO = Storyboard.taskHO.instantiateViewController(withIdentifier: "TaskHOVC") as? TaskHOVC
    static let confirmHO = Storyboard.ongoingDetailHO.instantiateViewController(withIdentifier: "ConfirmVC") as? ConfirmVC
     static let tabBar = Storyboard.tabBar.instantiateViewController(withIdentifier: "ContratorTabBarVC") as? ContratorTabBarVC
    static let project = Storyboard.project.instantiateViewController(withIdentifier: "ProjectVC") as? ProjectVC
    
    static let pastProjectCODetail = Storyboard.project.instantiateViewController(withIdentifier: "PastProjectCODetailVC") as? PastProjectCODetailVC
    
    static let material = Storyboard.material.instantiateViewController(withIdentifier: "MaterialVC") as? MaterialVC
    static let materialDetailsCO = Storyboard.material.instantiateViewController(withIdentifier: "MaterialDetailsCOVC") as? MaterialDetailsCOVC
    static let invitation = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationVC") as? InvitationVC
    static let invitationFilter = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationFilterVC") as? InvitationFilterVC
    static let invitationDetail = Storyboard.invitation.instantiateViewController(withIdentifier: "InvitationDetailsVC") as? InvitationDetailsVC
    static let message = Storyboard.message.instantiateViewController(withIdentifier: "MessageVC") as? MessageVC
    static let profile = Storyboard.profile.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
    
//    static let ContractorSetting = Storyboard.profile.instantiateViewController(withIdentifier: "ContractorSettingVC") as? ContractorSettingVC
    
    static let AddEditBankDetail = Storyboard.profile.instantiateViewController(withIdentifier: "AddEditBankDetailVC") as? AddEditBankDetailVC
    
//    static let ContractorEditProfile = Storyboard.profile.instantiateViewController(withIdentifier: "ContractorEditProfile") as? ContractorEditProfile
    
    static let onGoingProfile = Storyboard.onGoingProfile.instantiateViewController(withIdentifier: "OngoingVC") as? OngoingVC
    static let pastProjectCO = Storyboard.pastProject.instantiateViewController(withIdentifier: "PastProjectVC") as? PastProjectVC
    static let archiveProfile = Storyboard.archiveProfile.instantiateViewController(withIdentifier: "ArchiveProfileVC") as? ArchiveProfileVC
    
    static let mainProjectTask = Storyboard.mainProjectTask.instantiateViewController(withIdentifier: "MainProjectTaskVC") as? MainProjectTaskVC
    static let mainProject = Storyboard.mainProject.instantiateViewController(withIdentifier: "MainProjectVC") as? MainProjectVC
    
    static let orderMaterialCO = Storyboard.mainProject.instantiateViewController(withIdentifier: "OrderMaterialVC") as? OrderMaterialVC
    static let tasks = Storyboard.tasks.instantiateViewController(withIdentifier: "TasksVC") as? TasksVC
    static let orderlist = Storyboard.orderlist.instantiateViewController(withIdentifier: "OrderlistVC") as? OrderlistVC
    
    static let subTaskProject = Storyboard.subTaskProject.instantiateViewController(withIdentifier: "SubTaskProjectVC") as? SubTaskProjectVC
    static let subTask = Storyboard.subTask.instantiateViewController(withIdentifier: "SubTaskVC") as? SubTaskVC
    static let subTaskOrderList = Storyboard.subTaskOrderList.instantiateViewController(withIdentifier: "SubTaskOrderListVC") as? SubTaskOrderListVC
    
    static let pastMainProjectTask = Storyboard.pastMainProjectTask.instantiateViewController(withIdentifier: "PastMainProjectTaskVC") as? PastMainProjectTaskVC
    static let pastMainProject = Storyboard.pastMainProject.instantiateViewController(withIdentifier: "PastMainProjectVC") as? PastMainProjectVC
    static let pastTasks = Storyboard.pastTasks.instantiateViewController(withIdentifier: "PastTasksVC") as? PastTasksVC
    static let pastOrderlist = Storyboard.pastOrderlist.instantiateViewController(withIdentifier: "PastOrderlistVC") as? PastOrderlistVC
    
    static let pastSubTaskProject = Storyboard.pastSubTaskProject.instantiateViewController(withIdentifier: "PastSubTaskProjectVC") as? PastSubTaskProjectVC
    static let pastSubTask = Storyboard.pastSubTask.instantiateViewController(withIdentifier: "PastSubTaskVC") as? PastSubTaskVC
    static let pastSubOrderList = Storyboard.pastSubOrderList.instantiateViewController(withIdentifier: "PastSubOrderListVC") as? PastSubOrderListVC
    
    static let archiveMainProjectTask = Storyboard.archiveMainProjectTask.instantiateViewController(withIdentifier: "ArchiveProjectTaskVC") as? ArchiveProjectTaskVC
    static let archiveMainProject = Storyboard.archiveMainProject.instantiateViewController(withIdentifier: "ArchiveMainProjectVC") as? ArchiveMainProjectVC
    static let archiveTasks = Storyboard.archiveTasks.instantiateViewController(withIdentifier: "ArchiveTasksVC") as? ArchiveTaskVC
    static let archiveOrderlist = Storyboard.archiveOrderlist.instantiateViewController(withIdentifier: "ArchiveOrderlistVC") as? ArchiveOrderlistVC
    static let viewBidHO = Storyboard.newHO.instantiateViewController(withIdentifier: "ViewBidsVC") as? ViewBidsVC
    static let bidDetailHO = Storyboard.newHO.instantiateViewController(withIdentifier: "BidDetailVc") as? BidDetailVc
    static let acceptBidHO = Storyboard.newHO.instantiateViewController(withIdentifier: "AcceptBidVc") as? AcceptBidVc
    static let rejectBidHO = Storyboard.newHO.instantiateViewController(withIdentifier: "RejectBidVC") as? RejectBidVC
    static let transaction = Storyboard.mainProject.instantiateViewController(withIdentifier: "TransactionVC") as? TransactionVC
    
    static let addNewTaskVC = Storyboard.project.instantiateViewController(withIdentifier: "AddNewTaskVC") as? AddNewTaskVC
    
    
    static let agreementHO = Storyboard.newHO.instantiateViewController(withIdentifier: "AgreementVC") as? AgreementVC
    
    static let contractorCO = Storyboard.project.instantiateViewController(withIdentifier: "ContractorVC") as? ContractorVC
    static let subTaskCO = Storyboard.project.instantiateViewController(withIdentifier: "SubTaskProjectVC") as? SubTaskProjectVC
    static let addNewTaskCO = Storyboard.project.instantiateViewController(withIdentifier: "AddNewTaskVC") as? AddNewTaskVC

    
    static let pastProjectSubTaskCOVC = Storyboard.pastProjectSubTaskCO.instantiateViewController(withIdentifier: "PastProjectSubTaskCOVC") as? PastProjectSubTaskCOVC

    static let orderListMaterial = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderItemListVC") as? OrderItemListVC
    static let orderListDetailMaterial = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "OrderListDetailVC") as? OrderListDetailVC
    
//    static let notificationHO = Storyboard.projectHO.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
    static let feedBacksHO = Storyboard.feedBackHO.instantiateViewController(withIdentifier: "FeedBackHOVC") as? FeedBackHOVC
    static let feedBacksSubmitHO = Storyboard.feedBackHO.instantiateViewController(withIdentifier: "FeedBackSubmitVC") as? FeedBackSubmitVC
    static let HelpAndSupportHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "HelpAndSupportVC") as? HelpAndSupportVC
    static let TermsAndConditionHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "TermsAndConditionVC") as? TermsAndConditionVC
    static let PrivacyPolicyHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as? PrivacyPolicyVC
    static let FAQHO = Storyboard.profileHO.instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
    static let vendorDetail = Storyboard.material.instantiateViewController(withIdentifier: "VendorDetailVC") as? VendorDetailVC
}



