//
//  TNTabBarController.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/4/22.
//

import UIKit

class TNTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createNewsNC()]
    }
    
    func createNewsNC() -> UINavigationController {
        let newsVC = NewsViewController()
        let newsIcon = UIImage(systemName: "newspaper")
        newsVC.title = "News"
        newsVC.tabBarItem = UITabBarItem(title: "News", image: newsIcon, tag: 0)
        return UINavigationController(rootViewController: newsVC)
    }
    
}
