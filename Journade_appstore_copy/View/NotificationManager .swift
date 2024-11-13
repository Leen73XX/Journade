//
//  NotificationManager .swift
//  Journade_appstore_copy
//
//  Created by mariyam yasin on 09/05/1446 AH.
//

import UserNotifications
import SwiftUI

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted.")
                self.scheduleDailyNotification()
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // Clear previous notifications, if any
        
        // Array of notification titles
        let notificationTitles = [
            "Unlock Today’s Story",
            "Clear the Clutter, Refresh Your Mind",
            "Preserve Your Best Moments",
            "Take a Moment, Reflect and Recharge",
            "Your Thoughts Deserve to Be Heard",
            
        ]
        
        // Array of motivational sentences
        let motivationalSentences = [
            "Capture today’s moments—make them unforgettable.",
            "Release stress and feel refreshed. Start writing now.",
            "Save today’s memories—big or small.",
            "Take a breath, reflect, and write your thoughts.",
            "Every thought is worth recording. Start today!",
            
        ]
        
        
        // Select a random sentence and title
        let randomSentence = motivationalSentences.randomElement() ?? "Have a wonderful day!"
        let randomTitle = notificationTitles.randomElement() ?? "Keep Track of Your Day"
        
        let content = UNMutableNotificationContent()
        content.title = randomTitle
        content.body = randomSentence
        content.sound = .default
        
        // Set up the trigger to fire at 12:00 PM every day
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

