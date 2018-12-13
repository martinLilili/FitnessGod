//
//  AppDelegate.swift
//  FitnessGod
//
//  Created by cruzr on 2018/11/21.
//  Copyright © 2018 martin. All rights reserved.
//

import UIKit

import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var lastDate : Date? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.isIdleTimerDisabled = true
        
        // 使用 UNUserNotificationCenter 来管理通知
        // 使用 UNUserNotificationCenter 来管理通知
        let center = UNUserNotificationCenter.current()
        // 监听回调事件
        center.delegate = self
        //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
        /*
         UNAuthorizationOptionBadge   = (1 << 0),
         UNAuthorizationOptionSound   = (1 << 1),
         UNAuthorizationOptionAlert   = (1 << 2),
         */
        center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { granted, error in
            if granted {
                print("通知注册成功")
            }
        })
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("applicationDidEnterBackground")
        if !TimerView.share.isHidden {
            MCGCDTimer.shared.cancleTimer(WithTimerName: "GCDTimer")
            lastDate = Date()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        if !TimerView.share.isHidden {
            if lastDate != nil {
                let i = CFDateGetTimeIntervalSinceDate(Date() as CFDate, lastDate! as CFDate)
                TimerView.share.time += i
                TimerView.share.startTimer()
            }
            lastDate = nil
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
