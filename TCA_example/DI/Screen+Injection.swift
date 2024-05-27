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
    var loginScreen: ParameterFactory<(AuthFlowAction) -> Void, LoginScreen> {
        self { performNavigation in
            let store = Store(initialState: LoginFeature.State()) {
                LoginFeature(performNavigation: performNavigation)
            }
            return LoginScreen(store: store)
        }
    }

    var onboardingScreen: ParameterFactory<(AuthFlowAction) -> Void, OnboardingScreen> {
        self { performNavigation in
            let store = Store(initialState: OnboardingFeature.State()) {
                OnboardingFeature(performNavigation: performNavigation)
            }
            return OnboardingScreen(store: store)
        }
    }

    var registerScreen: ParameterFactory<(AuthFlowAction) -> Void, RegisterScreen> {
        self { performNavigation in
            let store = Store(initialState: RegisterFeature.State()) {
                RegisterFeature(performNavigation: performNavigation)
            }
            return RegisterScreen(store: store)
        }
    }

    var settingsScreen: ParameterFactory<(SettingsFlowAction) -> Void, SettingsScreen> {
        self { performNavigation in
            let store = Store(initialState: SettingsFeature.State()) {
                SettingsFeature(performNavigation: performNavigation)
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

    var topMovieScreen: ParameterFactory<(MovieFlowAction) -> Void, TopMoviesScreen> {
        self { performNavigation in
            let store = Store(initialState: TopMovieFeature.State()) {
                TopMovieFeature(performNavigation: performNavigation)
            }
            return TopMoviesScreen(store: store)
        }
    }

    var movieDetailScreen: ParameterFactory<(Int, (MovieFlowAction) -> Void), MovieDetailScreen> {
        self { params in
            let store = Store(initialState: MovieDetailFeature.State()) {
                MovieDetailFeature(id: params.0, performNavigation: params.1)
            }
            return MovieDetailScreen(store: store)
        }
    }

    var notificationScreen: ParameterFactory<(NotificationFlowAction) -> Void, NotificationScreen> {
        self { performNavigation in
            let store = Store(initialState: NotificationFeature.State()) {
                NotificationFeature(performNavigation: performNavigation)
            }
            return NotificationScreen(store: store)
        }
    }
}
