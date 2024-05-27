//
//  NotificationFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 29/05/2024.
//

import ComposableArchitecture
import Factory
import UserNotifications

@Reducer
struct NotificationFeature {
    @Injected(\.notificationRepository) private var repository
    let performNavigation: (NotificationFlowAction) -> Void

    @ObservableState
    struct State {
        var notificationStatus = UNAuthorizationStatus.notDetermined
        var isGranted = false
        var isEnabled: Bool {
            return notificationStatus == .authorized
        }
    }

    enum Action {
        case openSettings
        case checkNotificationStatus
        case requestNotification
        case updateStatus(UNAuthorizationStatus)
        case sendNotification(NotificationType)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .checkNotificationStatus:
                return .run { send in
                    let status = await repository.checkNotificationStatus()
                    await send(.updateStatus(status))
                }
            case .requestNotification:
                return .run { send in
                    _ = try await repository.requestPermission()
                    await send(.checkNotificationStatus)
                }
            case .updateStatus(let status):
                state.notificationStatus = status
                return .none
            case .openSettings:
                repository.openAppSettings()
                return .none
            case .sendNotification(let type):
                repository.scheduleNotification(type: type)
                return .none
            }
        }
    }
}
