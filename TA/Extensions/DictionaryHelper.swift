//
//  DictionaryHelper.swift
//  Fakhroo
//
//  Created by developer on 06/12/17.
//  Copyright © 2017 Applify. All rights reserved.
//

import UIKit

extension NSDictionary {
    
    func objectForKeyIsNull(key:String) -> Bool {
        if self.object(forKey:key) is NSNull {
            return true
        }
        if (self.object(forKey:key) == nil) {
            return true
        }
        return false
    }

    
    func objectForKeyAsString(key:String) -> String {
        if self.object(forKey:key) is NSNull{
            return ""
        }
        
        if (self.object(forKey:key) == nil) {
            return ""
        }
        
        return String(format:"%@",self.object(forKey:key) as! CVarArg)
    }
    
    
    func objectForKeyAsDouble(key:String) -> Double {
        if self.object(forKey:key) is NSNull{
            return 0
        }
        
        if (self.object(forKey:key) == nil) {
            return 0
        }
        
        if String(format:"%@",self.object(forKey:key) as! CVarArg).count == 0 {
            return 0.0
        }
        
         return Double(String(format:"%@",self.object(forKey:key) as! CVarArg))!
    }
    
    
    func objectForKeyAsInt(key:String) -> Int {
        if self.object(forKey:key) is NSNull{
            return 0
        }
        
        if (self.object(forKey:key) == nil) {
            return 0
        }
        
        if String(format:"%@",self.object(forKey:key) as! CVarArg).count == 0 {
            return 0
        }
        
        return Int(String(format:"%@",self.object(forKey:key) as! CVarArg))!
    }
}


