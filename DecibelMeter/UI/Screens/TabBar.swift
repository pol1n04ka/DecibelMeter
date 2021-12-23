//
//  TabBar.swift
//  DecibelMeter
//
//  Created by Polina Prokopenko on 11/19/21.
//

import UIKit


class TabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        selectedIndex = 1
    }
    
}


extension TabBar {
    
    private func setupView() {
        let saved     = SavedView()
        let savedIcon = UITabBarItem(
            title: "Saved",
            image: UIImage(named: "Save")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "SaveSelected")?.withRenderingMode(.alwaysOriginal)
        )
        saved.tabBarItem = savedIcon
        
        let home     = RecordView()
        let homeIcon = UITabBarItem(
            title: nil,
            image: UIImage(named: "Home")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "HomeSelected")?.withRenderingMode(.alwaysOriginal)
        )
        home.tabBarItem = homeIcon
        
        let settings     = SettingsView()
        let settingsIcon = UITabBarItem(
            title: "Settings",
            image: UIImage(named: "Settings")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "SettingsSelected")?.withRenderingMode(.alwaysOriginal)
        )
        settings.tabBarItem = settingsIcon
        
        let views = [saved, home, settings]
        
        viewControllers = views
        
        self.tabBar.backgroundColor         = UIColor(named: "BackgroundColorTabBar")
        self.tabBar.isTranslucent           = false
        self.tabBar.barTintColor            = UIColor(named: "BackgroundColorTabBar")
        self.tabBar.tintColor               = .white
        self.tabBar.unselectedItemTintColor = .white
    }
    
}
