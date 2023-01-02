//
//  TA_Storage.swift
//  SiteDrop
//
//  Created by applify on 07/04/21.
//

import Foundation

class TA_Storage: NSObject {

    class TA_Storage_Constants  {
        static let kApproved = "approved"
        static let kIsLoggedIn = "approved"
        static let kIsSignedUp = "approved"
        static let kIsRememberMe = "rememberMe"
        static let kIsRememberMeEmail = "rememberMeEmail"
        static let kIsRememberMePassword = "rememberMePassword"
        static let kPersonalDetailsData = "personalDetailsData"
        static let kProfileCreated = "profileCreated"
    }
    
    static let shared = TA_Storage()

    //MARK:- Booleans
    
    var iskProfileCreated :Bool {
        get {
            UserDefaults.standard.bool(forKey: TA_Storage_Constants.kProfileCreated)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TA_Storage_Constants.kProfileCreated)
            UserDefaults.standard.synchronize()
        }
    }
    
    var isRememberLogin :Bool {
        get {
            UserDefaults.standard.bool(forKey: TA_Storage_Constants.kIsRememberMe)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TA_Storage_Constants.kIsRememberMe)
            UserDefaults.standard.synchronize()
        }
    }
    
    var isLoggedIn:Bool {
        get {
            UserDefaults.standard.bool(forKey: TA_Storage_Constants.kIsLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TA_Storage_Constants.kIsLoggedIn)
            UserDefaults.standard.synchronize()
        }
    }
    
    var isSignedUp:Bool {
        get {
            UserDefaults.standard.bool(forKey: TA_Storage_Constants.kIsSignedUp)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TA_Storage_Constants.kIsSignedUp)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK:- String
    var apiAccessToken:String{
        get {
            return("\(UserDefaults.standard.value(forKey: "accessToken") ?? "")")
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    var userId:Int {
        get {
            return UserDefaults.standard.value(forKey: "id") as? Int ?? -1
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: "id")
        }
    }
    
    var rememberLoginEmail :String {
        get{
            return("\(UserDefaults.standard.value(forKey: TA_Storage_Constants.kIsRememberMeEmail) ?? "")")
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: TA_Storage_Constants.kIsRememberMeEmail)
        }
    }
    
    var rememberLoginPassword :String {
        get{
            return("\(UserDefaults.standard.value(forKey: TA_Storage_Constants.kIsRememberMePassword) ?? "")")
        }
        set(newValue){
            UserDefaults.standard.set(newValue, forKey: TA_Storage_Constants.kIsRememberMePassword)
        }
    }
}

extension UserDefaults {

   func save<T:Encodable>(customObject object: T, inKey key: String) {
       let encoder = JSONEncoder()
       if let encoded = try? encoder.encode(object) {
           self.set(encoded, forKey: key)
       }
   }

   func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
       if let data = self.data(forKey: key) {
           let decoder = JSONDecoder()
           if let object = try? decoder.decode(type, from: data) {
               return object
           }else {
               print("Couldnt decode object")
               return nil
           }
       }else {
           print("Couldnt find key")
           return nil
       }
   }
}
