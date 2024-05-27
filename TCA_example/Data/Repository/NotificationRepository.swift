//
//  NotificationRepository.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 30/05/2024.
//

import Foundation
import UserNotifications
import UIKit

protocol NotificationRepository {
    func requestPermission() async throws -> Bool
    func scheduleNotification(type: NotificationType)
    func checkNotificationStatus() async -> UNAuthorizationStatus
    func openAppSettings()
}

class NotificationRepositoryImpl: NotificationRepository {
    func requestPermission() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: granted)
                }
            }
        }
    }

    func scheduleNotification(type: NotificationType) {
        let content = UNMutableNotificationContent()
        content.title = R.string.localizable.notificationArrived()
        content.body = type.body
        content.sound = .default
        content.userInfo = ["type": type.rawValue]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func checkNotificationStatus() async -> UNAuthorizationStatus {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                continuation.resume(returning: settings.authorizationStatus)
            }
        }
    }

    func openAppSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
        }
    }
}
