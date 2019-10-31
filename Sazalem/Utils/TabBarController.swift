//
//  TabBarController.swift
//  Sazalem
//
//  Created by Esset Murat on 1/25/18.
//  Copyright © 2018 Esset Murat. All rights reserved.
//

import UIKit
import Alamofire

class TabBarController : UITabBarController {        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        tabBar.tintColor = .blue
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let singersViewController = SingersViewController()
        let singersNavController = UINavigationController(rootViewController: singersViewController)
        singersViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "singers"), tag: 0)
        singersViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        singersViewController.tabBarItem.title = nil*/

        let topViewController = TopViewController()
        let topNavController = UINavigationController(rootViewController: topViewController)
        topViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "singers"), tag: 0)
        topViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        topViewController.tabBarItem.title = nil
        
        let homeViewController = HomeViewController()
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "hit"), tag: 1)
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        homeViewController.tabBarItem.title = nil
        
        let favouriteViewController = FavouriteViewController()
        let favouriteNavController = UINavigationController(rootViewController: favouriteViewController)
        favouriteViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "like"), tag: 2)
        favouriteViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        favouriteViewController.tabBarItem.title = nil
        
        let profileViewController = SettingsViewController()
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "settings"), tag: 3)
        profileViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        profileViewController.tabBarItem.title = nil
        
        if NetworkReachabilityManager()!.isReachable {
            viewControllers = [homeNavController, topNavController, favouriteNavController, profileNavController]
        } else {
            viewControllers = [favouriteNavController, profileNavController]
        }
    }
}
