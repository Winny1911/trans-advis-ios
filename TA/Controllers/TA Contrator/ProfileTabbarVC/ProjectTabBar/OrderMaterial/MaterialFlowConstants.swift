//
//  MaterialFlowConstants.swift
//  TA
//
//  Created by Shikha Pandey on 07/02/22.
//

import Foundation

extension APIUrl{
    
    static var contractor: String {
        return baseUrl + "contractor/"
    }
    
//https://p2-testapi.ta123test.com:443/api
//https://p2-testapi.ta123test.com:443/admin/content-management/productCategories/list

    struct OrderMaterialApis {
        
        static let vendorList                           = contractor              + "vendor/list"
        
    }
    
    static let productCategoriesList                    = host                 + "/admin/content-management/productCategories/list"
}
