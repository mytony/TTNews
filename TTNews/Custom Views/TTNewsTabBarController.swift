//
//  TNTabBarController.swift
//  TTNews
//
//  Created by Meng-Yu Chung on 1/4/22.
//

import UIKit

class TTNewsTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createNewsNavigationController(), createSettingsNavigationController()]
    }
    
    func createNewsNavigationController() -> UINavigationController {
        let newsVC = NewsViewController()
        let newsIcon = UIImage(systemName: "newspaper")
        let selectedIcon = UIImage(systemName: "newspaper.fill")
        newsVC.title = "News"
        newsVC.tabBarItem = UITabBarItem(title: "News", image: newsIcon, selectedImage: selectedIcon)
        return UINavigationController(rootViewController: newsVC)
    }
    
    func createSettingsNavigationController() -> UINavigationController {
        let settingsVC = SettingsViewController()
        let settingsIcon = UIImage(systemName: "gearshape")
        let selectedIcon = UIImage(systemName: "gearshape.fill")
        settingsVC.title = "Settings"
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: settingsIcon, selectedImage: selectedIcon)
        return UINavigationController(rootViewController: settingsVC)
    }
}
