//
//  TabBarHOVM.swift
//  TA
//
//  Created by Dev on 09/12/21.
//

import UIKit
import Foundation

struct OnboardTabHOViewModel {
    var selectedImage: String
    var unselectedImage: String
    var titleName: String
}

class OnboardViewHOModel: NSObject {
    var tabItemsModel: [OnboardTabHOViewModel] = [OnboardTabHOViewModel(selectedImage: "ic_HO_projects", unselectedImage: "Ic_projects-1", titleName: "Projects"),
                                                  OnboardTabHOViewModel(selectedImage: "ic_contractors", unselectedImage: "ic_HO_contractor", titleName: "Contractors"),
                                                  OnboardTabHOViewModel(selectedImage: "add-button", unselectedImage: "add-button", titleName: ""),

                                                  OnboardTabHOViewModel(selectedImage: "ic_message-1", unselectedImage: "ic_HO_message", titleName: "Message"),
                                                  OnboardTabHOViewModel(selectedImage: "Ic_profile-1", unselectedImage: "ic_HO_profile", titleName: "Profile"),
                                                ]

}
