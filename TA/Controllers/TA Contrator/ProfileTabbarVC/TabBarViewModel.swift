//
//  TabBarViewModel.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import Foundation

struct ProjectTabViewModel {
    var selectedImageName: String
    var unselectedImageName: String
    var title: String
}

class ProjectViewModel: NSObject {
    var tabsViewModel: [ProjectTabViewModel] = [ProjectTabViewModel(selectedImageName: "Ic_projects-2", unselectedImageName: "Ic_projects-1", title: "Projects"),
                                                ProjectTabViewModel(selectedImageName: "ic_material-1", unselectedImageName: "ic_material", title: "Material"),
                                                ProjectTabViewModel(selectedImageName: "ic_Invitations-1", unselectedImageName: "ic_Invitations", title: "Invitations"),
                                                ProjectTabViewModel(selectedImageName: "ic_message-1", unselectedImageName: "Ic_message", title: "Message"),
                                                ProjectTabViewModel(selectedImageName: "Ic_profile-1", unselectedImageName: "Ic_profile", title: "Profile")]
    
}


