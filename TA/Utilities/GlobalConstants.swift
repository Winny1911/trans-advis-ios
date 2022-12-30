//
//  GlobalConstants.swift
//  TA
//
//  Created by Applify  on 09/12/21.
//

import Foundation
import UIKit
import CoreGraphics // for using CGFloat

struct StaticUrl {
    static let pdfUrl            = "https://transadvisor-dev.s3.amazonaws.com/projectUploads/16407606177540045.pdf"
}

struct SucessMessage {
    static let emailSentSuccessfully            = "Email Sent Successfully"
    static let projectSentSuccessfully          = "Project invitation sent successfully"
    static let bidRecalledSuccessfully          = "Bid Recalled Successfully"
    static let bidRejectedSuccessfully          = "Bid Rejected Successfully"
    static let bidAcceptSuccessfully            = "Bid Accepted Successfully"
    static let VerifyEmailSuccessfully          = "Verification link has been sent in your email"
    
}

struct CharacterLimit {
}

struct StringConstants {
    
}
struct ValidationError {
}


extension ValidationError {
    static let emptyEmail                       = "Please enter your Email"
    static let invalidEmail                     = "Please enter valid Email"
    static let selectUserType                   = "Please select any Role"
    
    static let emptyPassword                    = "Please enter Password"
    
    static let emptyOldPassword                    = "Please enter Old Password"
    static let emptyNewPassword                    = "Please enter New Password"
    static let emptyConfirmPassword                = "Please enter Confirm Password"
    
    static let wrongPassword                     = "Please enter Right Password"
    
    static let notMatchPassword                     = "New Password and Confirm  Password do not match"
    static let samePassword                     = " Old Password and New Password should not same"
    static let validPasswordSpace               = "Blank spaces are not allowed"
    static let invalidPasswordChar              = "Password should be a minimum of 8 characters and a maximum of 20 character."
    static let invalidPassword                  = "Password must contain 8 alphanumeric Characters"
    static let acceptTerms                      = "Please accept the terms and conditions"
    
    static let emptyProfileImage                = "Please select profile image"
    static let emptyFirstName                   = "Please enter First Name"
    static let emptyLastName                    = "Please enter Last Name"
    static let invalidFirstName                 = "First name should be minimum of 3 and maximum of 40 characters"
    static let invalidLastName                  = "Last name should be minimum of 3 and maximum of 40 characters"
    static let emptyPhoneNumber                 = "Please enter Phone Number "
    static let invalidPhoneNumber               = "Phone Number should be of 10 digits"
    static let emptySkillSet                    = "Please select atleast 1 skill"
    
    static let emptyLicenseNumber               = "Please enter License Number"
    static let licenseDoc                       = "Please upload a digital copy of the licence"

    static let emptyFindLocation                = "Please enter Location"
    static let emptyAddress                      = "Please enter Address"
    static let emptyStreet                      = "Please enter Address Line 1"
    static let emptyCity                        = "Please enter City"
    static let emptyState                       = "Please enter State"
    static let emptyZipcode                     = "Please enter Zip Code"
    static let emptyZipcodes                    = "Please enter Zipcodes"
    static let validZipcode                     = "Please enter valid Zipcodes"
    static let validImageCount                  = "You can upload 150 image only"
    
    static let emptyAccountNumber               = "Please enter Account Number"
    static let emptyAccountName                 = "Please enter Account Holder Name"
    static let emptyRouting                     = "Please enter Routing Number"
    static let invalidRouting                   = "Routing Number should be of 9 digits"
    static let invalidSSN                       = "Business tax ID should be of 9 digits" //"SSN should be of 9 digits"
    static let invalidAccountNumber             = "Account Number should be a minimum of 10 digits and a maximum of 20 digits."
    static let invalidLicence                   = "Licence Number should be a minimum of 10 digits."
    
    
    static let emptyProjectTitle                = "Please enter Project Title"
    static let projectFiles                     = "Please select Project File"
    static let invalidProjectTitle              = "Project Title should be minimum of 3 and maximum of 100 characters"
    static let emptyProjectDescription          = "Please enter Project Description"
    static let invalidProjectDesc               = "Project Description should be minimum of 3 and maximum of 1000 characters"
    static let emptyDeliverable                 = "Please add Deliverables"
    static let emptyFieldDeliverable            = "Please enter Deliverables"
    static let emptyProjectType                 = "Please select Project type"
    static let emptyProjectBudget               = "Please add Project Budget"
    static let emptyTaskImage                   = "Please upload Task File"
    static let emptyMarkCompleteImage           = "Please upload File"
    
    static let emptyBidAmount                   = "Please enter Bid Amount"
    static let emptyAmountReceivable            = "Please enter Amount Receivable"
    static let emptyStartDate                   = "Please enter Proposed Start Date"
    static let emptyEndDate                     = "Please enter Proposed End Date"
    static let emptyTermsDesc                   = "Please enter Terms / Description"
    static let emptyProjectFile                 = "Please Select Project File"
    static let validEndDate                     = "End date should be greater than start date"
    static let emptyEVerificationDoc            = "Please select E-Verification Doc"
    static let emptyPaymentProof                = "Please select Payment Proof"
    static let emptyTaskName                    = "Please enter Task Name"
    static let emptyTaskBudget                  = "Please enter Task Budget"
    static let emptySelectedProject             = "Please select any project"
    static let enteryourBio                     = "Please enter your Bio."
    static let characterCount                   = "Bio should be atleast 10 characters."
    static let emptyDiscription                 = "Please add Description"
    
}
