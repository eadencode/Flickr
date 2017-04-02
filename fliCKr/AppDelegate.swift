//
//  AppDelegate.swift
//  fliCKr
//
//  Created by CK on 3/31/17.
//  Copyright © 2017 CK. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        layoutTabBarContainer()
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // MARK : Customizations and container view controllers.
    
    func layoutTabBarContainer() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navforNowPlaying = storyboard.instantiateViewController(withIdentifier: "mainNavController") as! UINavigationController
        let nowPlayingViewController = navforNowPlaying.topViewController as! MoviesListControllerViewController
        nowPlayingViewController.queryFor = "now_playing"
        navforNowPlaying.tabBarItem.title = "Now Playing"
        navforNowPlaying.tabBarItem.image = AppUtils.imagesizeToFit(image: UIImage(named:"now_playing@1x")!, newSize: CGSize(width:30,height:30), offset: CGPoint(x: 0, y: 0))
        
        let navForTopRated = storyboard.instantiateViewController(withIdentifier: "mainNavController") as! UINavigationController
        let topRatedViewController = navForTopRated.topViewController as! MoviesListControllerViewController
        topRatedViewController.queryFor = "top_rated"
        navForTopRated.tabBarItem.title = "Top Rated"
        navForTopRated.tabBarItem.image = AppUtils.imagesizeToFit(image: UIImage(named:"top_rated@1x")!, newSize: CGSize(width:30,height:30), offset: CGPoint(x: 0, y: 0))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navforNowPlaying, navForTopRated]
        tabBarController.view.backgroundColor = UIColor.black
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barTintColor = UIColor.black
        tabBarController.tabBar.tintColor = UIColor.white
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }


}

