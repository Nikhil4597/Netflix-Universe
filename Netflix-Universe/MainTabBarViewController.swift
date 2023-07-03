//
//  ViewController.swift
//  Netflix-Universe
//
//  Created by ROHIT MISHRA on 03/07/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        tabBar.tintColor = .label
    }

    func setUpTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let upComingVC = UINavigationController(rootViewController: UpcomingViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadVC = UINavigationController(rootViewController: DownloadsViewController())
        let userInfoVC = UINavigationController(rootViewController: UserInfoViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        upComingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        userInfoVC.tabBarItem.image = UIImage(systemName: "person")
        
        homeVC.title = "Home"
        upComingVC.title = "Upcoming"
        searchVC.title = "Search"
        downloadVC.title = "Download"
        userInfoVC.title = "userInfo"
        
        setViewControllers([homeVC,upComingVC,searchVC,downloadVC,userInfoVC], animated: true)
    }
}

