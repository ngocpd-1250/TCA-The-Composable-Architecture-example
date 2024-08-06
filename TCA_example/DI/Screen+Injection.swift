//
//  Store+Injection.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 21/05/2024.
//

import Foundation
import Factory
import ComposableArchitecture

extension Container {
    var loginScreen: Factory<LoginScreen> {
        self {
            let store = Store(initialState: LoginFeature.State()) {
                LoginFeature()
            }
            return LoginScreen(store: store)
        }
    }

    var onboardingScreen: Factory<OnboardingScreen> {
        self {
            let store = Store(initialState: OnboardingFeature.State()) {
                OnboardingFeature()
            }
            return OnboardingScreen(store: store)
        }
    }

    var registerScreen: Factory<RegisterScreen> {
        self {
            let store = Store(initialState: RegisterFeature.State()) {
                RegisterFeature()
            }
            return RegisterScreen(store: store)
        }
    }

    var settingsScreen: Factory<SettingsScreen> {
        self {
            let store = Store(initialState: SettingsFeature.State()) {
                SettingsFeature()
            }
            return SettingsScreen(store: store)
        }
    }

    var topTodoScreen: ParameterFactory<StoreOf<TopTodoFeature>, TopTodoScreen> {
        self { store in
            TopTodoScreen(store: store)
        }
    }

    var todoListScreen: ParameterFactory<(StoreOf<TodoListFeature>, TodoCategory), TodoListScreen> {
        self { params in
            let (store, category) = params
            store.send(.setCategory(category))
            return TodoListScreen(store: store)
        }
    }

    var addNewTodoScreen: ParameterFactory<StoreOf<NewTodoFeature>, NewTodoScreen> {
        self { store in
            NewTodoScreen(store: store)
        }
    }

    var topMovieScreen: Factory<TopMoviesScreen> {
        self {
            let store = Store(initialState: TopMovieFeature.State()) {
                TopMovieFeature()
            }
            return TopMoviesScreen(store: store)
        }
    }

    var movieDetailScreen: ParameterFactory<Int, MovieDetailScreen> {
        self { id in
            let store = Store(initialState: MovieDetailFeature.State()) {
                MovieDetailFeature(id: id)
            }
            return MovieDetailScreen(store: store)
        }
    }

    var notificationScreen: Factory<NotificationScreen> {
        self {
            let store = Store(initialState: NotificationFeature.State()) {
                NotificationFeature()
            }
            return NotificationScreen(store: store)
        }
    }
}
