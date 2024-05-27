//
//  NotificationScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 29/05/2024.
//

import SwiftUI
import ComposableArchitecture

struct NotificationScreen: View {
    @Bindable var store: StoreOf<NotificationFeature>
    @Environment(\.scenePhase) private var scenePhase

    init(store: StoreOf<NotificationFeature>) {
        self.store = store
    }

    var body: some View {
        Screen {
            VStack {
                Button {
                    if store.notificationStatus == .notDetermined {
                        store.send(.requestNotification)
                    } else if store.notificationStatus == .denied {
                        store.send(.openSettings)
                    }
                } label: {
                    if store.notificationStatus == .notDetermined {
                        Text(R.string.localizable.notificationGrantPermission())
                            .foregroundStyle(Color(R.color.primary))
                    } else if store.notificationStatus == .denied {
                        Text(R.string.localizable.notificationOpenSettings())
                            .foregroundStyle(Color(R.color.primary))
                    } else {
                        Text(R.string.localizable.notificationGranted())
                            .foregroundStyle(Color(R.color.primary))
                    }
                }
                .disabled(store.notificationStatus == .authorized)

                Spacer()
                    .frame(height: Spacing.large.value)

                ForEach(NotificationType.allCases) { type in
                    BaseButton(title: type.buttonTitle, isEnabled: store.isEnabled) {
                        store.send(.sendNotification(type))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .padding(.top, Spacing.normal.value)
                }

                Spacer()
                    .frame(height: 50)
            }
            .padding(.horizontal)
        }
        .onAppear {
            store.send(.checkNotificationStatus)
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            switch newScenePhase {
            case .active:
                // App moved to the foreground
                store.send(.checkNotificationStatus)
            default:
                break
            }
        }
    }
}
