//
//  AppDelegate.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-12.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
        let storyboardOnboard = UIStoryboard(name: "onboardScreen", bundle: nil)
        var vc: UIViewController
        
        
        Database.database().isPersistenceEnabled = true
   
        unowned let userdefaults = UserDefaults.standard
        let notificationDelegate = NotificationDelegate()
        
        
        
        //Remove duplicate blocks bug
            
            let persistenceManager = PersistenceManager.shared
        
        
        

            do {

                let context = try persistenceManager.context.fetch(Blocks.fetchRequest()) as! [Blocks]


                           var blocks: [Blocks] = context
                           blocks = context.filter { (b) -> Bool in
                            b.block == Int16(1) && b.semester == Int16(1)
                           }



                if blocks.count > 1 {

                    persistenceManager.context.delete(blocks.last!)

                }



                           blocks = context.filter { (b) -> Bool in
                               b.block == Int16(2) && b.semester == Int16(1)
                           }

                if blocks.count > 1 {

                    persistenceManager.context.delete(blocks.last!)

                }


                           blocks = context.filter { (b) -> Bool in
                               b.block == Int16(3) && b.semester == Int16(1)
                           }

                if blocks.count > 1 {

                    persistenceManager.context.delete(blocks.last!)

                }


                           blocks = context.filter { (b) -> Bool in
                               b.block == Int16(4) && b.semester == Int16(1)
                           }

                if blocks.count > 1 {

                    persistenceManager.context.delete(blocks.last!)

                }


                           blocks = context.filter { (b) -> Bool in
                               b.blockX == true && b.semester == Int16(1)
                           }

                if blocks.count > 1 {

                    persistenceManager.context.delete(blocks.last!)

                }

                blocks = context.filter { (b) -> Bool in
                              b.block == Int16(1) && b.semester == Int16(2)
                             }



                  if blocks.count > 1 {

                      persistenceManager.context.delete(blocks.last!)

                  }



                             blocks = context.filter { (b) -> Bool in
                                 b.block == Int16(2) && b.semester == Int16(2)
                             }

                  if blocks.count > 1 {

                      persistenceManager.context.delete(blocks.last!)

                  }


                             blocks = context.filter { (b) -> Bool in
                                 b.block == Int16(3) && b.semester == Int16(2)
                             }

                  if blocks.count > 1 {

                      persistenceManager.context.delete(blocks.last!)

                  }


                             blocks = context.filter { (b) -> Bool in
                                 b.block == Int16(4) && b.semester == Int16(2)
                             }

                  if blocks.count > 1 {

                      persistenceManager.context.delete(blocks.last!)

                  }


                             blocks = context.filter { (b) -> Bool in
                                 b.blockX == true && b.semester == Int16(2)
                             }

                  if blocks.count > 1 {

                      persistenceManager.context.delete(blocks.last!)

                  }



                           persistenceManager.save()

                       } catch {
                           print(error)
                       }


        
        
        if userdefaults.value(forKey: "FirstLaunch") != nil {
            
            vc = storyboardMain.instantiateInitialViewController()!
            print("Not First Launch")
            
        } else {
            
            vc = storyboardOnboard.instantiateViewController(withIdentifier: "OnboardingViewController")
          
             print("First Launch")
            
            
 
        }
        
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
        
        //Temporary feature
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
        
        //Temporary feature
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        unowned let userdefaults = UserDefaults.standard
         let storyboardOnboard = UIStoryboard(name: "onboardScreen", bundle: nil)
        
        if userdefaults.value(forKey: "isFirstLaunch") == nil {
            
            if let vc = storyboardOnboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController  {
                
                if !vc.isReachable() {
                    
                    let internetAlert = UIAlertController(title: "No Connection", message: "WiFi is needed for first-time setup", preferredStyle: UIAlertController.Style.alert)
                    
                    let findNetworkAction = UIAlertAction(title: "Network Settings", style: UIAlertAction.Style.default) { (action) in
                        
                        vc.openSettings()
                        
                    }
                    
                    internetAlert.addAction(findNetworkAction)
                    
                    UIApplication.shared.keyWindow?.rootViewController?.present(internetAlert, animated: true, completion: nil)
                   
                    
                } else {
                    
                    //Setup
                    vc.setupNotifications()
                    vc.setupClubs()
                    vc.setupSports()
                    vc.setupSchedule()
                    vc.setupTeachers()
                    vc.setupCalendar()
                    
                    unowned let userdefaults = UserDefaults.standard
                    userdefaults.set(true, forKey: "isFirstLaunch")
                    
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

