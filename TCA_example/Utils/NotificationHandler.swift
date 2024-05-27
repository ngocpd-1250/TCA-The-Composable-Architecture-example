//
//  NotificationHandler.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 30/05/2024.
//

import SwiftUI

final class NotificationHandler: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var notification: NotificationType?

    /// Display notification in foreground
    func userNotificationCenter(_: UNUserNotificationCenter,
                                willPresent _: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    /// Handle notification response
    func userNotificationCenter(_: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let type = userInfo["type"] as? String,
              let notification = NotificationType(rawValue: type) else {
            return
        }
        self.notification = notification
        completionHandler()
    }
}
