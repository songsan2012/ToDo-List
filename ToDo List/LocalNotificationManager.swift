//
//  LocalNotificationManager.swift
//  ToDo List
//
//  Created by song on 1/17/22.
//  Copyright © 2022 song. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

struct LocalNotificationManager {
    
    
    static func authorizeLocalNotification(viewController: UIViewController) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // -- If there is an error, kick out and handle error
            guard error == nil else {
                print("😡 ERROR: \(error!.localizedDescription)")
                return
            }
            
            // -- If granted
            if granted {
                print("✅ Notifications Authorization Granted!")
                // TODO: Look into what else to do when authorized.
            }
            else {
                print("🚫 The user has denied notifications!")
                
                DispatchQueue.main.async {
                    
                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
                }
            }
        }
    }
    
    
    static func isAuthorized(completed: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // -- If there is an error, kick out and handle error
            guard error == nil else {
                print("😡 ERROR: \(error!.localizedDescription)")
                completed(false)
                return
            }
            
            // -- If granted
            if granted {
                print("✅ Notifications Authorization Granted!")
                completed(true)
                // TODO: Look into what else to do when authorized.
            }
            else {
                print("🚫 The user has denied notifications!")
                completed(false)
//                DispatchQueue.main.async {
//
//                    viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", message: "To receive alerts for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
//                }
            }
        }
    }
    
    
    static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound, date: Date) -> String {
        
        // -- Create Content:
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        // -- Create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        
        // -- Create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        // -- Register request with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription) Yikes, adding notification request went wrong!")
            }
            else {
                print("Notification schedule \(notificationID), title: \(content.title)")
                
                // FIXME: Need to do something with this
            }
        }
        
        return notificationID
        
    }
    
    
}
