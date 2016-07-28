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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        // initialize environment
        UserDefaultManager.registerDefaultsFromSettingsBundle()
        LanguageManager.setAppLanguage()
        
        // let the Launching Screen stay for several seconds
        NSThread.sleepForTimeInterval(1.0)

        // set root view controller

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()

        let gameListVCtrl = GameListVC()
        let gameListNavCtrl = UINavigationController(rootViewController: gameListVCtrl)
        gameListNavCtrl.tabBarItem.title = LanguageManager.getAppLanguageString("game.tabbaritem.title")
        gameListNavCtrl.tabBarItem.image = UIImage(named: "GameNavItem")

        let toolListVCtrl = ToolListVC()
        let toolListNavCtrl = UINavigationController(rootViewController: toolListVCtrl)
        toolListNavCtrl.tabBarItem.title = LanguageManager.getAppLanguageString("tool.tabbaritem.title")
        toolListNavCtrl.tabBarItem.image = UIImage(named: "ToolNavItem")

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [gameListNavCtrl, toolListNavCtrl]

        window?.rootViewController = tabBarController

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        // To hide screen shot when entering background due to security
        UIApplication.sharedApplication().keyWindow?.hidden = true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // resume the keyWindow and show it to user
        UIApplication.sharedApplication().delegate?.window!!.hidden = false
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

