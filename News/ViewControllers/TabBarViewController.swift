//
//  TabBarViewController.swift
//  News
//
//  Created by Анатолий Миронов on 02.12.2021.
//

import UIKit

@available(iOS 13.0, *)
class TabBarViewController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        let categoriesVC = UINavigationController(rootViewController: CategoriesCollectionViewController())
        mainVC.title = "Main"
        categoriesVC.title = "Categories"
        
        setViewControllers([mainVC, categoriesVC], animated: true)
        
        guard let tabBarItems = tabBar.items else { return }
        
        let tabBarImages = ["house", "rectangle.grid.2x2"]
        
//        for number in 0..<tabBarItems.count {
//            tabBarItems[number].image = UIImage(systemName: tabBarImages[number])
//        }
        
        for (tabBarItem, tabBarImage) in zip(tabBarItems, tabBarImages) {
            tabBarItem.image = UIImage(systemName: tabBarImage)
        }
        
        tabBar.selectedItem?.badgeValue = "1"
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 0.7012882864)
        
        
    }

}
