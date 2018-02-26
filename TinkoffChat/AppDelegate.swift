//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by comandante on 2/25/18.
//  Copyright © 2018 daniilgonchar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var currentAppState: UIApplicationState = UIApplication.shared.applicationState
    var previousAppState: UIApplicationState = UIApplication.shared.applicationState
    var tmpString: String?
    
    
    func detectStateString( crntState: UIApplicationState , prvState: UIApplicationState) -> String
    {
        var crntString: String
        var prvString: String

        
        switch crntState {
        case .active:
            crntString = "active_state"
        case .background:
            crntString = "background_state"
        case .inactive:
            crntString = "inactive_state"
        
        }
        
        switch prvState {
        case .active:
            prvString = "active_state"
        case .background:
            prvString = "background_state"
        case .inactive:
            prvString = "inactive_state"
        }
        
        return prvString + " to " + crntString
    }
    
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //optional binding
        
        if let _window = window {
            _window.rootViewController = ViewController()
            _window.makeKeyAndVisible()
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        currentAppState = UIApplication.shared.applicationState
        tmpString = detectStateString(crntState: currentAppState, prvState: previousAppState)
        print("Application moved from " + tmpString! + " method: applicationWillResignActive\n")
        previousAppState = currentAppState
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        currentAppState = UIApplication.shared.applicationState
        tmpString = detectStateString(crntState: currentAppState, prvState: previousAppState)
        print("Application moved from " + tmpString! + " method: applicationDidEnterBackground\n")
        previousAppState = currentAppState
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        currentAppState = UIApplication.shared.applicationState
        tmpString = detectStateString(crntState: currentAppState, prvState: previousAppState)
        print("Application moved from " + tmpString! + " method: applicationWillEnterForeground\n")
        previousAppState = currentAppState
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        currentAppState = UIApplication.shared.applicationState
        tmpString = detectStateString(crntState: currentAppState, prvState: previousAppState)
        print("Application moved from " + tmpString! + " method: applicationDidBecomeActive\n")
        previousAppState = currentAppState
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
        currentAppState = UIApplication.shared.applicationState
        tmpString = detectStateString(crntState: currentAppState, prvState: previousAppState)
        print("Application moved from " + tmpString! + " method: applicationWillTerminate\n")
        previousAppState = currentAppState
    }


}

