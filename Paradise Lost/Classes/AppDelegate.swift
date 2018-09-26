//
//  AppDelegate.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/12/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // MARK: - Application life cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // initialize environment
        UserDefaultManager.registerDefaultsFromSettingsBundle()
        LanguageManager.setAppLanguage()
        
        // check jailbroken
        if CheckJailBroken.isJailBroken() {
            LogFileManager.printLogFile("This device is jailbroken!")
            return false
        }
        
        // let the Launching Screen stay for several seconds
        Thread.sleep(forTimeInterval: 1.0)

        // set root view controller

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let gameListVCtrl = GameListVC()
        let gameListNavCtrl = UINavigationController(rootViewController: gameListVCtrl)
        gameListNavCtrl.tabBarItem.title = LanguageManager.getGameString(forKey: "tabbaritem.title")
        gameListNavCtrl.tabBarItem.image = UIImage(named: "GameNavItem")

        let toolListVCtrl = ToolListVC()
        let toolListNavCtrl = UINavigationController(rootViewController: toolListVCtrl)
        toolListNavCtrl.tabBarItem.title = LanguageManager.getToolString(forKey: "tabbaritem.title")
        toolListNavCtrl.tabBarItem.image = UIImage(named: "ToolNavItem")

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [gameListNavCtrl, toolListNavCtrl]

        window?.rootViewController = tabBarController

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // use TextEditor to open file from other applications
        let vc = TextEditorVC()
        vc.file = File(absolutePathUrl: url.standardizedFileURL)
        (self.window?.rootViewController as! UITabBarController).selectedIndex = 1
        ((self.window?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController)
            .topViewController?.navigationController?.pushViewController(vc, animated: true)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // To hide screen shot when entering background due to security
        UIApplication.shared.keyWindow?.isHidden = true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // resume the keyWindow and show it to user
        UIApplication.shared.delegate?.window!!.isHidden = false
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

