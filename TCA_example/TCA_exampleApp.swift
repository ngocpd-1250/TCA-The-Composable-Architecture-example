//
//  TCA_exampleApp.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 16/05/2024.
//

import SwiftUI
import Firebase

@main
struct TCA_exampleApp: App {
    private let notificationHandler = NotificationHandler()

    init() {
        FirebaseApp.configure()
        Appearance.configure()
        UNUserNotificationCenter.current().delegate = notificationHandler
    }

    var body: some Scene {
        WindowGroup {
            MainApp()
                .environmentObject(notificationHandler)
        }
    }
}
