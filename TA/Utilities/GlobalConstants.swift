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
    static let invalidPasswordChar              = "Password should be a minimum of 8 characters and a maximum of 16 character."
    static let invalidPassword                  = "Password must contain 8 alphanumeric Characters"
    static let acceptTerms                      = "Please accept the terms and conditions"
    
    static let emptyProfileImage                = "Please select profile image"
    static let emptyFirstName                   = "Please enter First Name"
    static let emptyLastName                    = "Please enter Last Name"
    static let invalidFirstName                 = "First name should be minimum of 3 and maximum of 50 characters"
    static let invalidLastName                  = "Last name should be minimum of 3 and maximum of 50 characters"
    static let emptyPhoneNumber                 = "Please enter Phone Number "
    static let invalidPhoneNumber               = "Phone Number should be minimum of 8 and maximum of 13 characters"
    static let emptySkillSet                    = "Please select atleast 1 skill"
    
    static let emptyLicenseNumber               = "Please enter License Number"
    static let licenseDoc                       = "Please upload a digital copy of the licence"
    
    //PlaceBid
    static let emptyColor2                           = "Please enter color"
    static let emptyDebrisRemoval2                   = "Please enter debris removal 2"
    static let emptyClaimNumber                      = "Please enter claim number"
    static let emptyTotalSQ                          = "Please enter total square footage"
    static let emptyFlatRoofSQ                       = "Please enter flat roof square footage"
    static let emptyHomeOwner1                       = "Please enter home owner 1 name"
    static let emptyRidgeVent                        = "Please indicate if ridge vent is present"
    static let emptySprayPaint                       = "Please indicate if spray paint is required"
    static let emptyPermit                           = "Please indicate if permit is required"
    static let emptyFe                               = "Please enter FE"
    static let emptyInsPartialApproved               = "Please indicate if insurance is partially approved"
    static let emptyHomeOwnerSign2                   = "Please enter homeo wner 2 signature"
    static let emptyTurtleVents                      = "Please indicate if turtle vents are present"
    static let emptyDeducible                        = "Please enter deductible"
    static let emptyPermaBoot123                     = "Please enter perma boot"
    static let emptyAntenna                          = "Please indicate if antenna is present"
    static let emptyMaterialLocation                 = "Please enter material location"
    static let emptyDumpsterLocation                 = "Please enter dumpster location"
    static let emptyHomeOwnerInitial1                = "Please enter home owner 1 initial"
    static let emptyHomeOwnerInitial2                = "Please enter home owner 2 initial"
    static let emptyPverheadProfit2                  = "Please enter overhead profit 2"
    static let emptyHoa                              = "Please enter HOA information"
    static let emptyColor1                           = "Please enter color 1"
    static let emptyStreetAddress                    = "Please enter street address"
    static let emptyDripEdgeF55                      = "Please indicate if drip edge F55 is present"
    static let emptyChimneyFlashing                  = "Please indicate if chimney flashing is present"
    static let emptyCellPhone                        = "Please enter cell phone number"
    static let emptySpecialInstructions              = "Please enter special instructions"
    static let emptyPaymentTerms1                    = "Please indicate payment Terms Deductible"
    static let emptyPaymentTerms2                    = "Please indicate payment Terms Finance"
    static let emptyEmailPlaceBid                    = "Please enter email address"
    static let emptyStyle                            = "Please enter style"
    static let emptyHomeOwnerSign1                   = "Please enter homeowner 1 signature"
    static let emptyLightningRod                     = "Please indicate if lightning rod is present"
    static let emptyDetachedGarageSQ                 = "Please enter detached garage square footage"
    static let emptyCutInstallRidgeVent              = "Please indicate if ridge vent is to be cut and installed"
    static let emptyRoofing1                         = "Please enter roofing 1"
    static let emptyRetail2                          = "Please enter retail 2"
    static let emptySyntheticUnderlayment            = "Please indicate if synthetic underlayment is present"
    static let emptyInsurance                        = "Please enter insurance information"
    static let emptyInsFullyApproved                 = "Please indicate if insurance is fully approved"
    static let emptyAtticFan                         = "Please indicate if attic fan is present"
    static let emptyRetailDepreciation               = "Please indicate if retail depreciation is required"
    static let emptySatelliteDish                    = "Please indicate if satellite dish is present"
    static let emptyDate                             = "Please enter date"
    static let emptyTotal                            = "Please enter total"
    static let emptyMainDwellingRoofSQ               = "Please enter main dwelling roof square footage"
    static let emptyPipeJack34                       = "Please enter pipe jack 34"
    static let emptyDebrisRemoval1                   = "Please enter debris removal 1"
    static let emptyMailingAddress                   = "Please enter mailing address"
    static let emptyCodeUpgrades                     = "Please enter code upgrades"
    static let emptyOverheadProfit1                  = "Please enter overhead profit 1"
    static let emptyRoofing2                         = "Please enter roofing 2"
    static let emptyBrand                            = "Please enter brand"
    static let emptyPermaBoot34                      = "Please enter perma boot 34"
    static let emptyRetail1                          = "Please enter retail"
    static let emptyShedSQ                           = "Please enter shed square"
    static let emptyPipeJack123                      = "Please enter pipe jack 123"
    static let emptyDecking                          = "Please enter decking"
    static let emptyHomeOwner2                       = "Please enter name of homeowner"
    static let emptyCounterFlashing                  = "Please enter counter flashing"
    static let emptyNotes                            = "Please enter notes"
    

    static let emptyFindLocation                = "Please enter Location"
    static let emptyAddress                     = "Please enter Address"
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
    static let emptyBankName                    = "Please enter Bank Name"
    static let emptyCompanyName                 = "Please enter Company Name"
    static let invalidCompanyName               = "Company name should be minimum of 3 and maximum of 50 characters"
    static let invalidBankName                  = "Bank name should be of 15 digits"
}
