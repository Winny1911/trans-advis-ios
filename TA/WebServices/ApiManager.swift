//
//  ApiManager.swift
//  Fitsentive
//
//  Created by Applify  on 15/07/21.
//

import Foundation
import Alamofire
import UIKit
class ApiManager<T: Codable>: BaseApiManager {
    class func makeApiCall(_ url: String,
                           params: [String: Any] = [:],
                           headers: [String: String]? = nil,
                           method: HTTPMethod = .post,
                           requiresPinning: Bool = true,
                           completion: @escaping ([String: Any]?,T?) -> Void) {
        print("Params ----->",params)
        print("Full Url ----->",url.replace(string: "//api", replacement: "/api"))
        print("Header ----->",headers)
        let dataRequest = self.getDataRequest(url,
                                              params: params,
                                              method: method,
                                              headers: headers,
                                              requiresPinning: requiresPinning)
        self.executeDataRequest(dataRequest, with: completion)
    }
    
    static func executeDataRequest(_ dataRequest: DataRequest,
                                   with completion: @escaping (_ result: [String: Any]?,_ model:T?) -> Void) {
        if ApiManager.isNetworkReachable == false {
            completion(getNoInternetError(),nil)
            return
        }
        dataRequest.responseJSON { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    guard let value = value as? [String: Any] else {
                        completion(self.getUnknownError(response.error?.localizedDescription),nil)
                        return
                    }
                    print ("success")
                    print("\(value)")
                    do{
                        guard let data = response.data else {completion(value,nil)
                            return
                        }
                        let user = try JSONDecoder().decode(T.self, from:data)
                        let statusCode = value["statusCode"] as? Int
                        if statusCode == 401{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LogoutCall"), object: nil)
                            completion(value,user)

                        }else{
                            completion(value,user)
                        }
                    }catch{
                        print(error)
                        completion(self.getUnknownError(error.localizedDescription), nil)
                    }
                case .failure:
                    print(self.getUnknownError(response.error?.localizedDescription))
                    completion(self.getUnknownError(response.error?.localizedDescription), nil)

                }
            }
        }
    }
}

class BaseApiManager: NSObject {
    class var isNetworkReachable: Bool {
        return NetworkReachabilityManager()?.isReachable == true
    }
    static  let sharedInstance = BaseApiManager()
    
    let sessionManager: Session = {
        let url = APIUrl.baseUrlWithOutHttp.replacingOccurrences(of: " ", with: "")
        let manager = ServerTrustManager(evaluators: [url: DisabledTrustEvaluator()])
        let configuration = URLSessionConfiguration.af.default
        
        return Session(configuration: configuration, serverTrustManager: manager)
    }()
        
    class func getDataRequest(_ url: String,
                              params: [String: Any] = [:],
                              method: HTTPMethod = .post,
                              headers: [String: String]? = nil,
                              requiresPinning: Bool) -> DataRequest {
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }
        let dataRequest: DataRequest
        
            dataRequest = AF.request(url,
                                     method: method,
                                     parameters: params,
                                     encoding: encoding,
                                     headers: httpHeaders)
        return dataRequest
    }
}

extension BaseApiManager {
    
    static func getNoInternetError() -> [String: Any] {
        return [APIConstants.message: GenericErrorMessages.noInternet,
                APIConstants.statusCode: 503]
    }
    
    static func getUnknownError(_ message: String? = nil) -> [String: Any] {
        if !isNetworkReachable {
            return getNoInternetError()
        } else {
            return [APIConstants.message: GenericErrorMessages.internalServerError,
                    APIConstants.statusCode: 503]
        }
    }
}
