//
//  Notifications.swift
//  Notifications
//
//  Created by Татьяна Кочетова on 05.06.2021.
//  Copyright © 2021 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSetttings()
        }
    }
    
    func getNotificationSetttings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    func scheduleNotification(notificationType: String) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        
        content.title = notificationType
        content.body =  "This is example how to create " + notificationType
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let identifire = "Local Notification"
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(
            identifier: userAction,
            actions: [snoozeAction, deleteAction],
            intentIdentifiers: [],
            options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the Local Notification Identifire")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notificationType: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action ")
        }
        
        completionHandler()
    }
}
