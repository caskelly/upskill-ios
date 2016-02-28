//
//  AppDelegate.swift
//  UpSkill
//
//  Created by Christopher Skelly on 8/6/15.
//  Copyright (c) 2015 Fourthlock. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var window: UIWindow? = {
    return UIWindow(frame: UIScreen.mainScreen().bounds)
  }()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window?.rootViewController = RootViewController()
    window?.makeKeyAndVisible()

    return true
  }

  func applicationWillResignActive(application: UIApplication) {

  }

  func applicationDidEnterBackground(application: UIApplication) {

  }

  func applicationWillEnterForeground(application: UIApplication) {

  }

  func applicationDidBecomeActive(application: UIApplication) {

  }

  func applicationWillTerminate(application: UIApplication) {

  }
}
