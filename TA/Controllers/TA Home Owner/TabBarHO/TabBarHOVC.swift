//
//  TabBarHOVC.swift
//  TA
//
//  Created by Dev on 09/12/21.
//

import UIKit

class TabBarHOVC: UITabBarController {
    
    let viewModel =  OnboardViewHOModel() //OnboardViewModels() // OnboardTabHOViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
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
                let tabViewModel = self.viewModel.tabItemsModel[index]
                tabBarItem.image = UIImage(named: tabViewModel.unselectedImage)
                tabBarItem.title = tabViewModel.titleName
                tabBarItem.selectedImage = UIImage(named: tabViewModel.selectedImage)
                tabBarItem.imageInsets = UIEdgeInsets(top: index == 2 ? -30 : -6, left: 0, bottom: -5, right: 0)
                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
            }
        }
    }
}

extension TabBarHOVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.restorationIdentifier == "TabCreateProjectVC" {
            if let currentVC = tabBarController.viewControllers![tabBarController.selectedIndex]  as? UINavigationController {
                let vc = Controllers.createProjectHO
                vc!.projectId = 0
                NotificationCenter.default.post(name: Notification.Name("IsCreateNewProject"), object: nil)
                currentVC.pushViewController(vc!, animated: true)
            } else{
                
            }
            return false
        }
        return true
    }
}
