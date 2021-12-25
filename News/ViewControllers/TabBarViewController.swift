//
//  TabBarViewController.swift
//  News
//
//  Created by Анатолий Миронов on 02.12.2021.
//

import UIKit

protocol CategoriesViewControllerDelegate {
    func setEmptyBadgeValue()
}

class TabBarViewController: UITabBarController {
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarViewControllers()
        setTabBarAppearance()
    }
    
    // MARK: - Private Methods
    private func setTabBarViewControllers() {
        let mainNC = UINavigationController(rootViewController: MainViewController())
        let categoriesNC = UINavigationController(rootViewController: CategoriesViewController())
        mainNC.title = "Main"
        categoriesNC.title = "Categories"
        setViewControllers([mainNC, categoriesNC], animated: true)
        
        guard let categoriesVC = categoriesNC.topViewController as? CategoriesViewController else { return }
        categoriesVC.delegate = self
    }
    
    private func setTabBarAppearance() {
        guard let tabBarItems = tabBar.items else { return }
        let tabBarImages = ["house", "rectangle.grid.2x2"]
        
        for (tabBarItem, tabBarImage) in zip(tabBarItems, tabBarImages) {
            tabBarItem.image = UIImage(systemName: tabBarImage)
        }
        
//      for number in 0..<tabBarItems.count {
//          tabBarItems[number].image = UIImage(systemName: tabBarImages[number])
//      }
        
        tabBarItems.last?.badgeValue = "1"
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0.7012882864)
    }
}

// MARK: - Categories View Controller Delegate
extension TabBarViewController: CategoriesViewControllerDelegate {
    func setEmptyBadgeValue() {
        guard let tabBarItems = tabBar.items else { return }
        tabBarItems.last?.badgeValue = nil
    }
}
