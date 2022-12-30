//
//  AppDelegate.swift
//  TA
//
//  Created by Applify  on 03/12/21.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftMessages
import Firebase
import FirebaseCore
import FirebaseCrashlytics
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var chatObserverArray = NSMutableArray()
    var chat_dialogue_id : String! = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initializeKeyboardManager()
        initializeSwiftMessages()
        initializeFirebase()
        initializePushNotifications()
        UIApplication.shared.statusBarStyle = .darkContent

        GMSServices.provideAPIKey("AIzaSyA7TOKIXqW2q4yrJlWwmj1-chcx6x0vv10")
        
        GMSPlacesClient.provideAPIKey("AIzaSyA7TOKIXqW2q4yrJlWwmj1-chcx6x0vv10")
//        GMSPlacesClient.provideAPIKey("AIzaSyALRTolnBTTX_rHrinVrM-qLpJ3fjvq2B0")
        return true
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: -  Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


extension AppDelegate {
    private func initializeKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
    }
    
    private func initializeSwiftMessages() {
        SwiftMessages.defaultConfig.presentationStyle = .top
        SwiftMessages.defaultConfig.duration = SwiftMessages.Duration.seconds(seconds: 3.0)
        //SwiftMessages.defaultConfig.preferredStatusBarStyle = .darkContent
    }
    
    private func initializeFirebase() {
        FirebaseApp.configure()
    }
    
    private func initializePushNotifications() {
        PushNotificationHandler.shared.configure()
        PushNotificationHandler.shared.askForPushNotifications { }
    }
}


//--------------------------------------------//
// MARK: - APPDELEGATE SINGLETON
//--------------------------------------------//
func appDelegate() -> AppDelegate{
    return  UIApplication.shared.delegate as! AppDelegate
}
