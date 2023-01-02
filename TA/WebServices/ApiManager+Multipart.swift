//
//  ApiManager+Multipart.swift
//  Fitsentive
//
//  Created by Applify  on 15/07/21.
//

import Alamofire
import Foundation

extension ApiManager {
    
    class func multipartRequestImage(_ url: String,
                                dataToUpload: Data,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        
        if let urlRequest = try? URLRequest(url: url,
                                            method: .put,
                                            headers: nil) {
//            print(params)
//            print(urlRequest)
            let request = AF.upload(multipartFormData: { multipartFormData in
                
                if dataToUpload.count > 0 {
                        multipartFormData.append(dataToUpload,
                                                 withName: "",
                                                 fileName: "",
                                                 mimeType: "")
                }
            }, with: urlRequest)
            
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
    
    class func multipartRequestSinglePost(_ url: String,
                                params: [String: Any] = [:],
                                dataToUpload: Data,
                                keyToUploadData: String,
                                fileNames: String,
                                headers: [String: String]? = nil,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }
        
        if let urlRequest = try? URLRequest(url: url,
                                            method: .post,
                                            headers: httpHeaders) {
            print(params)
            print(urlRequest)
            let request = AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in params {
                    let valueStr = "\(value)"
                    if let valueData = valueStr.data(using: .utf8) {
                        multipartFormData.append(valueData, withName: key)
                    }
                }
                multipartFormData.append(dataToUpload,
                                         withName: keyToUploadData,
                                         fileName: fileNames,
                                         mimeType: "")
            }, with: urlRequest)
            
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
//                        print ("success")
//                        print("\(value)")
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
    
    class func multipartRequestSingleWithoutImage(_ url: String,
                                params: [String: Any] = [:],
                                dataToUpload: Data,
                                keyToUploadData: String,
                                fileNames: String,
                                headers: [String: String]? = nil,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }
        
        if let urlRequest = try? URLRequest(url: url,
                                            method: .put,
                                            headers: httpHeaders) {
            print(params)
            print(urlRequest)
            let request = AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in params {
                    let valueStr = "\(value)"
                    if let valueData = valueStr.data(using: .utf8) {
                        multipartFormData.append(valueData, withName: key)
                    }
                }
//                multipartFormData.append(dataToUpload,
//                                         withName: keyToUploadData,
//                                         fileName: fileNames,
//                                         mimeType: "")
            }, with: urlRequest)
            
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
//                        print ("success")
//                        print("\(value)")
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
    
    class func multipartRequestSingle(_ url: String,
                                params: [String: Any] = [:],
                                dataToUpload: Data,
                                keyToUploadData: String,
                                fileNames: String,
                                headers: [String: String]? = nil,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }
        
        if let urlRequest = try? URLRequest(url: url,
                                            method: .put,
                                            headers: httpHeaders) {
            print(params)
            print(urlRequest)
            let request = AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in params {
                    let valueStr = "\(value)"
                    if let valueData = valueStr.data(using: .utf8) {
                        multipartFormData.append(valueData, withName: key)
                    }
                }
                multipartFormData.append(dataToUpload,
                                         withName: keyToUploadData,
                                         fileName: fileNames,
                                         mimeType: "")
            }, with: urlRequest)
            
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
//                        print ("success")
//                        print("\(value)")
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
    
    class func multipartRequest(_ url: String,
                                params: [String: Any] = [:],
                                dataToUpload: [Data],
                                keyToUploadData: [String],
                                fileNames: [String],
                                headers: [String: String]? = nil,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }
        
        if let urlRequest = try? URLRequest(url: url,
                                            method: .post,
                                            headers: httpHeaders) {
//            print(params)
//            print(urlRequest)
            let request = AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in params {
                    let valueStr = "\(value)"
                    if let valueData = valueStr.data(using: .utf8) {
                        multipartFormData.append(valueData, withName: key)
                    }
                }
                if dataToUpload.count > 0 {
                    for index in 0 ..< dataToUpload.count  {
                        let data = dataToUpload[index]
                        let key = keyToUploadData[index]
                        
                        let fileName = fileNames[index]
                        multipartFormData.append(data,
                                                 withName: key,
                                                 fileName: fileName,
                                                 mimeType: "")
                    }
                }
            }, with: urlRequest)
            
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
//                        print ("success")
//                        print("\(value)")
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
    
    class func multipartRequest(_ url: String,
                                params: [String: Any] = [:],
                                localFileUrl: URL,
                                keyToUploadData: String,
                                fileNames: String,
                                headers: [String: String]? = nil,
                                completion: @escaping (_ result: [String: Any]?) -> Void) {
        if NetworkReachabilityManager()?.isReachable == false {
            completion(getNoInternetError())
            return
        }
        
        var httpHeaders: HTTPHeaders?
        if let headers = headers {
            httpHeaders = HTTPHeaders(headers)
        }

        if var urlRequest = try? URLRequest(url: url,
                                            method: .post,
                                            headers: httpHeaders) {
            urlRequest.httpBody = params.percentEscaped().data(using: .utf8)
            

            print(params)
            print(urlRequest)
            
            var documentData = Data()
            do {
                let docData = try Data(contentsOf: localFileUrl)
                documentData = docData
            } catch {
                print ("loading file error")
            }
            let request = AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(documentData,
                                         withName: keyToUploadData,
                                         fileName: fileNames,
                                         mimeType: "")
            }, with: urlRequest)
            request.uploadProgress { progress in
            }
            request.responseJSON { response in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success(let value):
                        guard let value = value as? [String: Any] else {
                            completion(self.getNoInternetError())
                            return
                        }
//                        print ("success")
//                        print("\(value)")
                        completion(value)
                    case .failure:
                        completion(self.getUnknownError(response.error?.localizedDescription))
                    }
                }
            }
            request.resume()
        }
    }
    
    static func multipartUploadRequest(header: HTTPHeaders,param: [String: Any], image: UIImage, fileParam: String, url: String, completion: @escaping (_ result: [String: Any]?) -> Void) {
        
        let request = AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in param {
                multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
            }
            if let img = image.jpegData(compressionQuality: 0.8){
                multipartFormData.append(img, withName: fileParam, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)
        
        request.uploadProgress { progress in
            print("##########%%%%%%%%%%%\(progress)progress")
        }
        
        request.responseJSON { (response) in
            print(response.result)
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    guard let value = value as? [String: Any] else {
                        completion(self.getNoInternetError())
                        return
                    }
                    print ("success")
                    print("\(value)")
                    completion(value)
                case .failure:
                    completion(self.getUnknownError(response.error?.localizedDescription))
                }
            }
        }
    }
    
}
