//
//  AppDelegate.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 24/10/2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KeyProvider.readValues()
        // Override point for customization after application launch.
        return true
    }

}

