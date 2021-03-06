//
//  AppDelegate.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-12.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let persistenceManager = PersistenceManager.shared
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        //Setting configurations
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        let storyboardOnboard = UIStoryboard(name: "onboardScreen", bundle: nil)
        var vc: UIViewController
        
        unowned let userdefaults = UserDefaults.standard
        let notificationDelegate = NotificationDelegate()
        
        //Checking if it is first launch. If so it will start onboarding
        if userdefaults.value(forKey: "FirstLaunch") != nil {
                   
                   //Goes to user's feed
                   vc = storyboardMain.instantiateInitialViewController()!
                   print("Not First Launch")
                   
               } else {
                   
                   //Starts onboarding
                   vc = storyboardOnboard.instantiateViewController(withIdentifier: "OnboardingViewController")
                 
                    print("First Launch")
                   
                   
        
               }
        
    
      
        
        //Set up the initial view depending on launch
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
        
        //Omitting notification badges and setting up notifications
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //Continues onboarding after user has turned on wifi
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        unowned let userdefaults = UserDefaults.standard
         let storyboardOnboard = UIStoryboard(name: "onboardScreen", bundle: nil)
        
        if userdefaults.value(forKey: "isFirstLaunch") == nil {
            
            if let vc = storyboardOnboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController  {
                
                //Checking network status
                let networkController = NetworkController()
                
                if !networkController.checkWiFi() {
                    
                    let internetAlert = UIAlertController(title: "No Connection", message: "WiFi is needed for first-time setup", preferredStyle: UIAlertController.Style.alert)
                    
                    let findNetworkAction = UIAlertAction(title: "Network Settings", style: UIAlertAction.Style.default) { (action) in
                        
                        vc.openSettings()
                        
                    }
                    
                    internetAlert.addAction(findNetworkAction)
                    
                    //Shows network error
                  UIApplication.shared.keyWindow?.rootViewController?.present(internetAlert, animated: true, completion: nil)
                   
                    
                } else {
                    
                    //Setup
                    vc.setup()
                    
                    //Turns off onboarding for future launches
                    unowned let userdefaults = UserDefaults.standard
                    userdefaults.set(true, forKey: "isFirstLaunch")
                    
                    //Segues to user's feed after onboarding
                self.window?.rootViewController!.performSegue(withIdentifier: "gotoFeed", sender: nil)

                }
                
            }
            
     
        }

        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        

        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }



}

