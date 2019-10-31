//
//  AppDelegate.swift
//  Sazalem
//
//  Created by Esset Murat on 1/25/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit
import SVProgressHUD
import AVFoundation
import IQKeyboardManagerSwift
import GoogleMobileAds
import FBSDKCoreKit
import SwiftyVK
import GoogleSignIn


var indicator = SVProgressHUD.self
var musicViewController = MusicViewController()
var audioPlayer = STKAudioPlayer()
var vkDelegate : SwiftyVKDelegate?
var avPlayer = musicPlayer()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //IQKeyboardManager.sharedManager().enable = true
        //IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 50
        //IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        GADMobileAds.configure(withApplicationID: "ca-app-pub-7813891820290008~4500388926")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        vkDelegate = VKDelegate()
        GIDSignIn.sharedInstance().clientID = "114520283988-hkmnvikarkuq1ed1d3r12cias179nd5i.apps.googleusercontent.com"

        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true//Base on your function return type, it may be returning something else
        }
        gai.tracker(withTrackingId: "UA-47710588-18")
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
            window?.rootViewController = TabBarController()
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        UINavigationBar.appearance().barTintColor = .white
        UIApplication.shared.statusBarStyle = .default
        UINavigationBar.appearance().tintColor = .blue
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        UINavigationBar.appearance().isTranslucent = false
        
        do {
            _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch let error {
            print(error)
        }
        
        window?.makeKeyAndVisible()
 
        return true
    }
    
    let VK_SCHEME = "vk5501566"
    let FACEBOOK_SCHEME = "fb222765221441597"
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == VK_SCHEME {
            VK.handle(url: url, sourceApplication: sourceApplication)
            return true
        } else if url.scheme == FACEBOOK_SCHEME {
            let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
                application,
                open: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
            return facebookDidHandle
        } else {
            let googleDidHandle = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
            return googleDidHandle
        }
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
    
}

