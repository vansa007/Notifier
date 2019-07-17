//
//  AppDelegate.swift
//  Notifier
//
//  Created by vansa pha on 16/07/2019.
//  Copyright © 2019 Vansa Pha. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        pushNotificationEveryHour(application)
        
        //enable IQKeyboard
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func pushNotificationEveryHour(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            ShareInstance.shared.isAllowPushNotification = granted
        }
        application.registerForRemoteNotifications()
    }
    
    private func pushAction() {
        var modelArr = [NoteItemModel]()
        var results = DBManager.shared.getDataFromDb()
        results = results.sorted(byKeyPath: "id", ascending: false)
        modelArr.removeAll()
        for element in results {
            modelArr.append(element)
        }
        
        if modelArr.count == 0 || !ShareInstance.shared.isAllowPushNotification { return }
        let numberRandom = Int.random(in: 0 ..< modelArr.count)
        let pushModel = modelArr[numberRandom]
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = pushModel.title_note
        content.body = pushModel.meaning_note
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz", "noteId": pushModel.id]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("jsl", userInfo)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //NotificationCenter.default.post(name: Notification.Name("random_lession"), object: nil, userInfo: response.notification.request.content.userInfo)
        //pushAction()
        if let idx = response.notification.request.content.userInfo["noteId"] as? Int {
            ShareInstance.shared.notiItem = DBManager.shared.getDataFromDb(byId: idx)
        }
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

