//
//  AppDelegate.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atıcı on 4.08.2024.
//
import UserNotifications
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let historicalVC = MapsViewController()
               let navigationController = UINavigationController(rootViewController: historicalVC)
               
               window = UIWindow(frame: UIScreen.main.bounds)
               window?.rootViewController = navigationController
               window?.makeKeyAndVisible()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                  if granted {
                      print("Bildirim izni verildi.")
                  } else {
                      print("Bildirim izni verilmedi.")
                  }
              }
               
               return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

