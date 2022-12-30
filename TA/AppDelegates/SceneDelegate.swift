//
//  SceneDelegate.swift
//  TA
//
//  Created by Applify  on 03/12/21.
//

import UIKit

var deepLinkUserId = 0
var isDeepLink = false

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        if let userActivity = connectionOptions.userActivities.first{
            self.scene(scene, continue: userActivity)
            }
//        self.scene(scene, continue: connectionOptions.urlContexts.first)
        
    }
    
    @objc func switchToDataTabCont(){
        UIApplication.getTopViewController()?.tabBarController!.selectedIndex = 4
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        print("________________")
        print(userActivity.webpageURL?.absoluteString as Any) // original link as parameter for parsing function
        var components = URLComponents()
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL
            components = URLComponents(url: url!, resolvingAgainstBaseURL: true)!
        }
        print("+++++++++++\(components.path)")
            
        if let link = userActivity.webpageURL?.absoluteString {
            let co = link.split(separator: "/")
            let coside = co[2]
            var id = link.split(separator: "/" ).last
            deepLinkUserId = Int(id ?? "\(3)") ?? 0
            isDeepLink = true
            let myDictionary = ["userID": id] as NSDictionary
            //            if UIApplication.getTopViewController() is SplashVC {
            let obj = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData)
            var stringID = "\(obj?.id ?? 0)" ?? ""
            
            if UIApplication.getTopViewController() is SplashVC {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    if obj?.userType == "CO"{
                        if coside == "contractor-detail"{
                            //navigate to co side profile
                            //let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
                            //tabBarController?.selectedIndex = 4
                            //                       UIApplication.getTopViewController()?.navigationController?.dismiss(animated: true, completion: {})
                            //UIApplication.getTopViewController()?.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: {})
                            //let destinationViewController = Storyboard.profile.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
                            //  UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
                            UIApplication.getTopViewController()?.tabBarController?.selectedIndex = 4
                        }else{
                            //navigate to vendor user
                            let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "VenderProfilesCOVC") as? VenderProfilesCOVC
                            var idd = Int(id ?? "\(0)")
                            destinationViewController?.id = idd ?? 0 //Int(id)
                            UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
                        }
                    }
                    else if obj?.userType == "HO"{
                        let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorProfileHOVC") as? ContractorProfileHOVC
                        var idd = Int(id ?? "\(0)")
                        destinationViewController?.contractorID = idd ?? 0 //Int(id)
                        UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
                    }
                    
                }
            }
            else{
                if obj?.userType == "CO"{
                    if coside == "contractor-detail"{
                        //navigate to co side profile
                        //                        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
                        //                        tabBarController?.selectedIndex = 4
                        //                        UIApplication.getTopViewController()?.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: {})
                        //                        let destinationViewController = Storyboard.profile.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
                        //
                        //                        UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
                        UIApplication.getTopViewController()?.tabBarController?.selectedIndex = 4
                    }else{
                        //navigate to vendor user
                        let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "VenderProfilesCOVC") as? VenderProfilesCOVC
                        var idd = Int(id ?? "\(0)")
                        destinationViewController?.id = idd ?? 0 //Int(id)
                        UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
                    }
                }
                else if obj?.userType == "HO"{
                    // navigatev to co of HO side
                    let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorProfileHOVC") as? ContractorProfileHOVC
                    var idd = Int(id ?? "\(0)")
                    destinationViewController?.contractorID = idd ?? 0 //Int(id)
                    UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
                }
            }
            
            
            //            if id ?? "" == stringID {
            //                    //navigate to co side profile
            //                    let destinationViewController = Storyboard.profile.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
            //                    UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
            ////                UIApplication.getTopViewController()?.tabBarController?.selectedIndex = 5
            //                }
            //                else{
            //                    // navigatev to co of HO side
            //                    let destinationViewController = Storyboard.contractorHO.instantiateViewController(withIdentifier: "ContractorProfileHOVC") as? ContractorProfileHOVC
            //                    var idd = Int(id ?? "\(0)")
            //                    destinationViewController?.contractorID = idd ?? 0 //Int(id)
            //                    UIApplication.getTopViewController()?.navigationController?.pushViewController(destinationViewController!, animated: true)
            //                }
            
            //            }
            
            //            deepLinkUserId = Int(id ?? "\(3)") ?? 0
            //            isDeepLink = true
            //            let myDictionary = ["videoId": id] as NSDictionary
            //            if UIApplication.getTopViewController() is SplashVC {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            // NotificationCenter.default.post(name: Notification.Name("DeepLinkVideoScreen"), object: nil, userInfo: myDictionary as? [AnyHashable : Any])
            // }
            //            } else {
            //                if UIApplication.getTopViewController()?.isModal == true {
            //                    UIApplication.getTopViewController()?.dismiss(animated: false, completion: nil)
            //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //                        let newVC = PlayListStoryboard.videoDetail.instantiateViewController(withIdentifier: "VideoDetailVC") as! VideoDetailVC
            //                        newVC.videoId = myDictionary["videoId"] as? Int ?? 0
            //                        UIApplication.getTopViewController()?.navigationController?.pushViewController(newVC, animated: true)
            //                    }
            //                } else {
            //                    let newVC = PlayListStoryboard.videoDetail.instantiateViewController(withIdentifier: "VideoDetailVC") as! VideoDetailVC
            //                    newVC.videoId = myDictionary["videoId"] as? Int ?? 0
            //                    UIApplication.getTopViewController()?.navigationController?.pushViewController(newVC, animated: true)
            //                    }
        }
//        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

