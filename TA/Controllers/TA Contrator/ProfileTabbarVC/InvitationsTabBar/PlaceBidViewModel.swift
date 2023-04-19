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
        if model.homeOwnerInitial1.isEmpty {
            error = ValidationError.emptyHomeOwnerInitial1
            completion(nil, error)
            return
        } else if model.homeOwnerSign1.isEmpty {
            error = ValidationError.homeOwnerSign1
            completion(nil, error)
            return
        } else {
            completion(model, nil)
        }
    }
    
    func validatePlaceBidnModelHO(completion: (_ success:PlaceBidModel?, _ error: String?) -> Void) {
        error = nil
        if model.homeOwnerInitial2.isEmpty {
            error = ValidationError.emptyHomeOwnerInitial2
            completion(nil, error)
            return
        } else if model.homeOwnerSign2.isEmpty {
            error = ValidationError.homeOwnerSign2
            completion(nil, error)
            return
        } else {
            completion(model, nil)
        }
    }
 
    func setChimneyFlashing(checkedBlack: Bool, checkedBrown: Bool, checkedWhite: Bool, checkedCopper: Bool) -> String {
        if checkedBlack {
            return "Black"
        } else if checkedBrown {
            return "Brown"
        } else if checkedWhite {
            return "White"
        } else if checkedCopper {
            return "Copper"
        }
        return ""
    }
    
    func setSprayPaint(checkedBlack: Bool, checkedBrown: Bool, checkedWhite: Bool, checkedGrey: Bool) -> String {
        if checkedBlack {
            return "Black"
        } else if checkedBrown {
            return "Brown"
        } else if checkedWhite {
            return "White"
        } else if checkedGrey {
            return "Grey"
        }
        return ""
    }
    
    func setTurtleVents(checkedRemoveReplace: Bool, checkedDetachReset: Bool, checkedRemoveCoverHoles: Bool) -> String {
        if checkedRemoveReplace {
            return "Remove & Replace"
        } else if checkedDetachReset {
            return "Detach & Reset"
        } else if checkedRemoveCoverHoles {
            return "Remove & Cover Holes"
        }
        return ""
    }
    
    func setDripEdgeF55(checkedWhite: Bool, checkedBrown: Bool, checkedAlmond: Bool) -> String {
        if checkedWhite {
            return "White"
        } else if checkedBrown {
            return "Brown"
        } else if checkedAlmond {
            return "Almond"
        }
        return ""
    }
    
    func setRidgeVent(checkedOc: Bool,
                      checkedGaf: Bool,
                      checkedAirVent: Bool) -> String {
        if checkedOc {
            return "OC"
        } else if checkedGaf {
            return "GAF"
        } else if checkedAirVent {
            return "AIR VENT"
        }
        return ""
    }
    
    func setCounterFlashing(checkedBlack: Bool,
                            checkedBrown: Bool) -> String {
        if checkedBlack {
            return "Black"
        } else if checkedBrown {
            return "Brown"
        }
        return ""
    }
    
    func setSyntheticUnderlayment(checkedAegc: Bool,
                                  checkedIko: Bool,
                                  checkedOc: Bool) -> String {
        if checkedAegc {
            return "AEGC"
        } else if checkedIko {
            return "IKO"
        } else if checkedOc {
            return "OC"
        }
        return ""
    }
    
    
    func setAtticFan(checkedRemoveReplace: Bool, checkedDetachReset: Bool) -> String {
        if checkedRemoveReplace {
            return "Remove & Replace"
        } else if checkedDetachReset {
            return "Detach & Reset"
        }
        return ""
    }
    
    func setLightningRod(checkedDetachOnly: Bool,
                         checkedDetachDispose: Bool) -> String {
        if checkedDetachOnly {
            return "Detach Only"
        } else if checkedDetachDispose {
            return "Detach/Dispose"
        }
        return ""
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
