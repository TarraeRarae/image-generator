//
//  AppDelegate.swift
//  image-generator
//
//  Created by Alexey Zubkov on 29.05.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let imageNameInputCoordinator = MainTabbarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = MainTabbarController()
        window?.makeKeyAndVisible()
        return true
    }
}

