//
//  AddNewTaskModel.swift
//  TA
//
//  Created by Applify  on 11/01/22.
//

import Foundation
class AddNewTaskModel {
    
    var bidBudget: String = ""
    var taskName: String = ""
    
    init() {
    }
    
    init(bidBudget: String, taskName: String) {
        self.bidBudget = bidBudget
        self.taskName = taskName
    }
}

class AddNewOtherTaskModel {
    
    var taskName: String = ""
    var deliverables: [[String : Any]] = [[String : Any]]()
    var projectType: String = ""
    var budget: String = "0"
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zipcode: String = ""
    var isMediaSelected: Bool = Bool()
    
    
    init() {
    }
    
    init(taskName: String,deliverables: [[String : Any]],projectType: String,budget: String,address: String,city: String,state: String,zipcode: String,isMediaSelected:Bool) {
        self.taskName = taskName
        self.deliverables = deliverables
        self.projectType = projectType
        self.budget = budget
        self.address = address
        self.city = city
        self.state = state
        self.zipcode = zipcode
        
        self.isMediaSelected = isMediaSelected
    }
}
