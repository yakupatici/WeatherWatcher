//
//  TabBarController.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = HomePageViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Ana Sayfa", image: UIImage(systemName: "house.fill"), tag: 3)

        let forecastsViewController = MapsViewController()
        forecastsViewController.view.backgroundColor = .white
        forecastsViewController.tabBarItem = UITabBarItem(title: "Haritalar", image: UIImage(systemName: "map.fill"), tag: 2)

        let settingsViewController = SettingsViewController()
        settingsViewController.view.backgroundColor = .white
        settingsViewController.tabBarItem = UITabBarItem(title: "Ayarlar", image: UIImage(systemName: "gear"), tag: 5)

        let earthquakeViewController = EarthquakeViewController()
        earthquakeViewController.tabBarItem = UITabBarItem(title: "Haberler", image: UIImage(systemName: "newspaper"), tag: 1)

        let favoritesViewController = FavoritesViewController()
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "star.fill"), tag: 1)

        let favoritesNavController = UINavigationController(rootViewController: favoritesViewController)

        // Tab bar öğelerini ayarla (Ana sayfa ortada olacak şekilde)
        let tabBarList = [favoritesNavController, forecastsViewController, homeViewController,earthquakeViewController, settingsViewController]
        viewControllers = tabBarList

        // Uygulama açıldığında ana sayfa seçili olsun
        selectedIndex = 2

        // Tab bar arka plan ve seçili item renklerini ayarla
        tabBar.barTintColor = UIColor(red: 27/255, green: 36/255, blue: 64/255, alpha: 1.0) // Arka plan rengi
        tabBar.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0) // Seçili item rengi (Sarı)
    }
}
