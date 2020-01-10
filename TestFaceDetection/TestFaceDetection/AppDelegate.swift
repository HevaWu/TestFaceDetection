//
//  AppDelegate.swift
//  TestFaceDetection
//
//  Created by He Wu on 2020/01/10.
//  Copyright © 2020 He Wu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window?.rootViewController = MainTabViewController()
        return true
    }
}

