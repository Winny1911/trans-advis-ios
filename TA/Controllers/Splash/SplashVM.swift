//
//  SplashVM.swift
//  TA
//
//  Created by Applify  on 12/12/21.
//

import Foundation
import Alamofire
class SplashVM: NSObject {
    
    let animationDuration: Double = 1
    let animationDelay: Double = 1
    let animationStay: Double = 1
    var sessionExists: Bool = false
    
}

class AppVersion: NSObject {
    static let shared: AppVersion = AppVersion()
    
    private override init() {
    }

    func appVersionApi(){
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        let params = ["deviceType" : "1",
                      "version": appVersion ?? "1.0"]
        ApiManager<AppVersionResponseModel>.makeApiCall(APIUrl.UserApis.versionControl, params:params , headers: headers, method: .get) { (response, resultModel) in
            
            if resultModel?.statusCode == 200 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if let newUpdate = resultModel?.data?.new_update, newUpdate == 1 {
                        let topMostViewController = UIApplication.getTopViewController()
                        let alertController: UIAlertController = UIAlertController(title: "Update Transaction Advisor", message: "Transaction Advisor recommends that you update to the latest version for a seamless & enhanced performance of the app.", preferredStyle: .alert)
                        
                        if let forceUpdate = resultModel?.data?.force_update, forceUpdate != 1 {
                            let noThanks: UIAlertAction = UIAlertAction(title: "No Thanks", style: .default) { action -> Void in
                            }
                            
                            alertController.addAction(noThanks)
                        }
                        
                        let update: UIAlertAction = UIAlertAction(title: "Update", style: .default) { action -> Void in
                            //                        if let url = URL(string: "itms-apps://apple.com/app/id839686104") {
                            
                            if let url = URL(string: "itms-apps://apple.com") {
                                UIApplication.shared.open(url)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    exit(0)
                                }
                            }
                        }
                        
                        alertController.addAction(update)
                        
                        topMostViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
