//
//  Data+Injection.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import Factory
import FirebaseAuth
import SwiftData

extension Container {
    var auth: Factory<Auth> {
        Factory(self) { Auth.auth() }
    }

    var authRepository: Factory<AuthRepository> {
        Factory(self) { AuthRepositoryImpl() }
    }

    var settingsRepository: Factory<SettingsRepository> {
        Factory(self) { SettingsRepositoryImpl() }
    }

    var todoRepository: Factory<TodoRepository> {
        Factory(self) { TodosRepositoryImpl() }
    }

    var movieRepository: Factory<MovieRepository> {
        Factory(self) { MovieRepositoryImpl() }
    }

    var notificationRepository: Factory<NotificationRepository> {
        Factory(self) { NotificationRepositoryImpl() }
    }

    @MainActor
    var modelContext: Factory<ModelContext?> {
        Factory(self) {
            return (try? ModelContainer(for: TodoItem.self))?.mainContext
        }
        .singleton
    }
}
