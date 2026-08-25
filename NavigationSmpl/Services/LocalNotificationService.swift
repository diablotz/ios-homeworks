//
//  LocalNotificationService.swift
//  NavigationSmpl
//
//  Created by Timur Zakirov on 24/08/26.
//

import Foundation
import UserNotifications

class LocalNotificationService: NSObject {
    
    static let shared = LocalNotificationService()
    
    private override init() {
        
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
//   func requestPermission() {
//
//        Task {
//            
//            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
//            
//        }
//    }
//    
//    func checkPermission() async -> Bool {
//        
//        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus == .authorized
//        
//    }
    
    func registerForLastUpdatesIfPossible() {
        
        registerUpdatesCategory()
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            
            if let error {
                
                print("Ошибка запроса на разрешение: \(error.localizedDescription)")
                return
                
            }
            
            guard granted else {
                
                print("Уведомления запрещены!")
                return
            }
            
            self.sheduleLatestUpdatesNotification()
            
        }
        
    }
    
    private func sheduleLatestUpdatesNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "VK"
        content.body = "Посмотрите последние обновления!"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "updates"
        
        var date = DateComponents()
        date.hour = 19
        date.minute = 00
        
        let trigger = UNCalendarNotificationTrigger(
            
            dateMatching: date,
            repeats: true
            
        )
        
        let request = UNNotificationRequest(
            
            identifier: "latestUpdatesNotification",
            content: content,
            trigger: trigger
            
        )
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { error in
            if let error {
                
                print("Не удалось добавить уведомление: \(error.localizedDescription)")
                
            } else {
                
                print("Уведомление успешно добавлено")
                
            }
            
        }
    }
    
    private func registerUpdatesCategory() {
        
        let openAction = UNNotificationAction(
            
            identifier: "openUpdates",
            title: "Открыть",
            options: [.foreground]
            
        )
        
        let closeAction = UNNotificationAction(
            
            identifier: "closeUpdates",
            title: "Закрыть",
            options: [.destructive]
            
        )
        
        let updatesCategory = UNNotificationCategory(
            
            identifier: "updates",
            actions: [
                openAction,
                closeAction
            ],
            intentIdentifiers: [],
            options: []
            
        )
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.setNotificationCategories(
            [updatesCategory]
        )
        
    }
    
    
}


extension LocalNotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler( [.sound, .badge, .banner])
        
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
            
        switch response.actionIdentifier {
                
            case "openUpdates":
                print("выбрали Посмотреть")
            
            case "closeUpdates":
                print("выбрали Закрыть")
                
            case UNNotificationDefaultActionIdentifier:
                print("Открыли уведомление")
                
            case UNNotificationDismissActionIdentifier:
                print("Смахнули уведомление")
                
            default:    break
        }
            
        completionHandler()
            
    }
}
