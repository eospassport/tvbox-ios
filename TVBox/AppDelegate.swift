//
//  AppDelegate.swift
//  TVBox
//
//  Created by Vitaly Berg on 23/09/2018.
//  Copyright © 2018 Vitaly Berg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var moviesVC: MoviesViewController!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        moviesVC = MoviesViewController()
        window?.rootViewController = UINavigationController(rootViewController: moviesVC)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let comps = URLComponents(string: url.absoluteString)!
        if let host = comps.host {
            if host == "age" {
                if comps.path.starts(with: "/verify") {
                    moviesVC.showVerification()
                }
            }
        }
        return true
    }
}
