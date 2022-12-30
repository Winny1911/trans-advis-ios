//
//  ContratorTabBarVC.swift
//  TA
//
//  Created by Designer on 09/12/21.
//

import UIKit

class ContratorTabBarVC: UITabBarController {
    
    let viewModel = ProjectViewModel()
//    let viewModelWithRedDot = ProjectRedDotViewModel()
//    let viewModel = OnboardViewModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.borderWidth = 0
        self.tabBar.clipsToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        TA_Storage.shared.isLoggedIn = true
    }
        
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let tabBarItems = self.tabBar.items {
            for index in 0..<tabBarItems.count {
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.appBlack], for: .selected)
                let tabBarItem = tabBarItems[index]
                let tabViewModel = self.viewModel.tabsViewModel[index]
                tabBarItem.image = UIImage(named: tabViewModel.unselectedImageName)
                tabBarItem.title = tabViewModel.title
                tabBarItem.selectedImage = UIImage(named: tabViewModel.selectedImageName)
                tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: -5, right: 0)
                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
            }
        }
    }
}
