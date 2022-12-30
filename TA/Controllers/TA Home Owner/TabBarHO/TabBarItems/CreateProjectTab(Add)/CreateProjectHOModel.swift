//
//  CreateProjectHOVIewmodel.swift
//  TA
//
//  Created by Applify  on 20/12/21.
//

import Foundation
import UIKit

class CreateProjectHOModel {
    
    var projecTitle: String = ""
    var projecDescription: String = ""
    var deliverables: [[String : Any]] = [[String : Any]]()
    var projectType: Int = 0
    var price: Int = 0
    var street: String = ""
    var city: String = ""
    var state: String = ""
    var zipcode: String = ""

    var selectedTaskImageDoc: Int = 0
    var istaskImageSelected: Bool = Bool()
    var taskSelectedName: String = ""
    var taskSelectedImage: String = ""
    var typeSkillStr: String = ""
    
    init() {
    }
    
    init(projecTitle: String, projecDescription: String, deliverables: [[String : Any]], projectType: Int, price: Int, street: String, city: String, state: String, zipcode: String, selectedTaskImageDoc:Int, typeSkillStr:String) {
        self.projecTitle = projecTitle
        self.projecDescription = projecDescription
        self.deliverables = deliverables
        self.projectType = projectType
        self.price = price
        self.street = street
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.typeSkillStr = typeSkillStr
        self.selectedTaskImageDoc = selectedTaskImageDoc
    }
}
