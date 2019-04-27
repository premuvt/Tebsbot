//
//  AppDelegate.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 04/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  setUpHomePage()
        return true
    }
    
    
    func setUpHomePage() {

        // TODO: Move this to where you establish a user session
        // AutoLogin Check Method
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let user = UserDefaults.standard.object(forKey: "user")

        
        if user != nil {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "uploadReceiptNavigationController")
//            self.window?.rootViewController = controller
        
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = controller
            
        } else {
                navigatetoLoginPage()
        }
    }
    
    func removeUserdefaults() {
        let preference = UserDefaults.standard
        preference.removeObject(forKey: "user")
        preference.removeObject(forKey: "pass")
        preference.synchronize()
    }
    func navigatetoLoginPage() {
        removeUserdefaults()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller : LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.window?.rootViewController = viewcontroller
        return
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

