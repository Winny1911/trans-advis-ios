//
//  PlaceBidViewModel.swift
//  TA
//
//  Created by Applify  on 01/01/22.
//

import Foundation


class PlaceBidViewModel: NSObject {
    var model: PlaceBidModel = PlaceBidModel()
    var error: String? = .none
    
    func validatePlaceBidnModel(completion: (_ success:PlaceBidModel?, _ error: String?) -> Void) {
        error = nil
        if model.colorB.isEmpty {
            error = ValidationError.emptyColor2
            completion(nil, error)
            return
        } else if model.debrisRemoval.isEmpty {
            error = ValidationError.emptyDebrisRemoval2
            completion(nil, error)
            return
        } else if model.claimNumber.isEmpty {
            error = ValidationError.emptyClaimNumber
            completion(nil, error)
            return
        }  else if model.total.isEmpty {
            error = ValidationError.emptyTotalSQ
            completion(nil, error)
            return
        } else if model.flatRoofSQ.isEmpty {
            error = ValidationError.emptyFlatRoofSQ
            completion(nil, error)
            return
        } else if model.homeOwner.isEmpty {
            error = ValidationError.emptyHomeOwner1
            completion(nil, error)
            return
        } else if model.fe.isEmpty {
            error = ValidationError.emptyFe
            completion(nil, error)
            return
        } else if model.homeOwnerSecond.isEmpty {
            error = ValidationError.emptyHomeOwnerSign2
            completion(nil, error)
            return
        } else if model.airVent.isEmpty {
            error = ValidationError.emptyTurtleVents
            completion(nil, error)
            return
        } else if model.deducible.isEmpty {
            error = ValidationError.emptyDeducible
            completion(nil, error)
            return
        } else if model.permaBoot.isEmpty {
            error = ValidationError.emptyPermaBoot123
            completion(nil, error)
            return
        } else if model.materialLocation.isEmpty {
            error = ValidationError.emptyMaterialLocation
            completion(nil, error)
            return
        } else if model.dumpsterLocation.isEmpty {
            error = ValidationError.emptyDumpsterLocation
            completion(nil, error)
            return
        } else if model.homeOwnerDateBA.isEmpty {
            error = ValidationError.emptyHomeOwnerInitial2
            completion(nil, error)
            return
        } else if model.overheadProfit.isEmpty {
            error = ValidationError.emptyOverheadProfit1
            completion(nil, error)
            return
        } else if model.hoa.isEmpty {
            error = ValidationError.emptyHoa
            completion(nil, error)
            return
        } else if model.color.isEmpty {
            error = ValidationError.emptyColor1
            completion(nil, error)
            return
        } else if model.streetAddress.isEmpty {
            error = ValidationError.emptyStreetAddress
            completion(nil, error)
            return
        } else if model.cellPhone.isEmpty {
            error = ValidationError.emptyCellPhone
            completion(nil, error)
            return
        } else if model.specialInstructions.isEmpty {
            error = ValidationError.emptySpecialInstructions
            completion(nil, error)
            return
        } else if !model.paymentTermsDeductible {
            error = ValidationError.emptyPaymentTerms1
            completion(nil, error)
            return
        } else if !model.paymentTermsFinance {
            error = ValidationError.emptyPaymentTerms2
            completion(nil, error)
            return
        } else if model.email.isEmpty {
            error = ValidationError.emptyEmail
            completion(nil, error)
            return
        } else if model.style.isEmpty {
            error = ValidationError.emptyStyle
            completion(nil, error)
            return
        } else if model.homeOwnerBA.isEmpty {
            error = ValidationError.emptyHomeOwnerSign1
            completion(nil, error)
            return
        } else if model.detachOnly.isEmpty {
            error = ValidationError.emptyDetachedGarageSQ
            completion(nil, error)
            return
        } else if model.roofing.isEmpty {
            error = ValidationError.emptyRoofing1
            completion(nil, error)
            return
        } else if model.retailB.isEmpty {
            error = ValidationError.emptyRetail2
            completion(nil, error)
            return
        } else if model.insurance.isEmpty {
            error = ValidationError.emptyInsurance
            completion(nil, error)
            return
        } else if !model.insFullyApproved {
            error = ValidationError.emptyInsFullyApproved
            completion(nil, error)
            return
        } else if model.total.isEmpty {
            error = ValidationError.emptyTotal
            completion(nil, error)
            return
        } else if model.mainDwellingRoof.isEmpty {
            error = ValidationError.emptyMainDwellingRoofSQ
            completion(nil, error)
            return
        } else if model.pipeJack.isEmpty {
            error = ValidationError.emptyPipeJack34
            completion(nil, error)
            return
        } else if model.debrisRemoval.isEmpty {
            error = ValidationError.emptyDebrisRemoval1
            completion(nil, error)
            return
        } else if model.mailingAddress.isEmpty {
            error = ValidationError.emptyMailingAddress
            completion(nil, error)
            return
        } else if model.codeUpgrades.isEmpty {
            error = ValidationError.emptyCodeUpgrades
            completion(nil, error)
            return
        } else if model.overheadProfit.isEmpty {
            error = ValidationError.emptyOverheadProfit1
            completion(nil, error)
            return
        } else if model.roofingPrice.isEmpty {
            error = ValidationError.emptyRoofing2
            completion(nil, error)
            return
        } else if model.brand.isEmpty {
            error = ValidationError.emptyBrand
            completion(nil, error)
            return
        } else if model.homeOwnerFirst.isEmpty {
            error = ValidationError.emptyHomeOwnerInitial1
            completion(nil, error)
            return
        } else if model.permaBootB.isEmpty {
            error = ValidationError.emptyPermaBoot34
            completion(nil, error)
            return
        } else if model.shedSQ.isEmpty {
            error = ValidationError.emptyShedSQ
            completion(nil, error)
            return
        } else if model.decking.isEmpty {
            error = ValidationError.emptyDecking
            completion(nil, error)
            return
        } else if model.homeOwnerBA.isEmpty {
            error = ValidationError.emptyHomeOwner2
            completion(nil, error)
            return
        } else {
            completion(model, nil)
        }
    }
    
    func validEndDate(startDateString:String, endDateString:String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let startDate = formatter.date(from: startDateString)
        let endDate = formatter.date(from: endDateString)
        if startDate! > endDate! {
            return false
        } else {
            return true
        }
    }
    
    func addInvitationDocApi(localFileUrl:URL,  keyToUploadData:String, fileNames:String, _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
           ApiManager<SignupResponseModel>.multipartRequest(APIUrl.UserApis.contractorFileUpload, localFileUrl: localFileUrl, keyToUploadData:keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                 Progress.instance.hide()
                 print(response!)
                 if response?["statusCode"] as! Int == 200{
                     result(response)
                 }else{
                 showMessage(with: response?["message"] as? String ?? "")
             }
        }
    }
    
    func addInvitationImageApi(keyToUploadData:String,fileNames:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSinglePost(APIUrl.UserApis.contractorFileUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileNames, headers: headers) { (response) in
                Progress.instance.hide()
                print(response!)
                if response?["statusCode"] as! Int == 200{
                    result(response)
                }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func submitBidApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.postContractorBid, params: params, headers: headers, method: .post) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
    func updateBidApi(_ params :[String:Any],_ result:@escaping(AddBankAccountResponseModel?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": "\(TA_Storage.shared.apiAccessToken)"]
        ApiManager<AddBankAccountResponseModel>.makeApiCall(APIUrl.UserApis.postContractorBid, params: params, headers: headers, method: .put) { (response, resultModel) in
            Progress.instance.hide()
            if resultModel?.statusCode == 200{
                result(resultModel)
            }
            else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
    
}
