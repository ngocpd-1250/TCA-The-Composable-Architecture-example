//
//  HomeMainScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 27/05/2024.
//

import Foundation
import SwiftUI
import Defaults

struct HomeMainScreen: View {
    @Default(.language) var language
    @State var selectedTab: TabBarItemType = .movies
    @EnvironmentObject private var notificationHandler: NotificationHandler

    private let movieCoordinatorVM = MovieCoordinatorViewModel()
    private let todoCoordinatorVM = TodoCoordinatorViewModel()
    private let settingsCoordinatorVM = SettingsCoordinatorViewModel()
    private let notificationCoordinatorVM = NotificationCoordinatorViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            MovieCoordinator(viewModel: movieCoordinatorVM)
                .tabItem {
                    selectedTab == .movies ? TabBarItemType.movies.selectedImage : TabBarItemType.movies.image
                    Text(TabBarItemType.movies.title)
                }
                .tag(TabBarItemType.movies)

            TodoCoordinator(viewModel: todoCoordinatorVM)
                .tabItem {
                    selectedTab == .todos ? TabBarItemType.todos.selectedImage : TabBarItemType.todos.image
                    Text(TabBarItemType.todos.title)
                }
                .tag(TabBarItemType.todos)

            NotificationCoordinator(viewModel: notificationCoordinatorVM)
                .tabItem {
                    selectedTab == .notification ? TabBarItemType.notification.selectedImage : TabBarItemType.notification.image
                    Text(TabBarItemType.notification.title)
                }
                .tag(TabBarItemType.notification)

            SettingsCoordinator(viewModel: settingsCoordinatorVM)
                .tabItem {
                    selectedTab == .settings ? TabBarItemType.settings.selectedImage : TabBarItemType.settings.image
                    Text(TabBarItemType.settings.title)
                }
                .tag(TabBarItemType.settings)
        }
        .accentColor(Color(R.color.primary))
        .onChange(of: notificationHandler.notification) { _, newValue in
            guard let notification = newValue else {
                return
            }
            notificationHandler.notification = nil
            switch notification {
            case .movie:
                selectedTab = .movies
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    movieCoordinatorVM.performNavigation(.toMovieDetail(id: 12))
                }
            case .todo:
                selectedTab = .todos
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    todoCoordinatorVM.performNavigation(.toAddNewTodo)
                }
            case .settings:
                selectedTab = .settings
            }
        }
    }
}

enum TabBarItemType: Int, Hashable {
    case movies = 0
    case todos
    case notification
    case settings

    static let allValues: [TabBarItemType] = [.movies, .todos, .notification, .settings]
}

extension TabBarItemType {
    var image: Image? {
        switch self {
        case .movies:
            return Image(systemName: "house")
        case .todos:
            return Image(systemName: "folder")
        case .settings:
            return Image(systemName: "person")
        case .notification:
            return Image(systemName: "tray.circle")
        }
    }

    var selectedImage: Image? {
        switch self {
        case .movies:
            return Image(systemName: "house.fill")
        case .todos:
            return Image(systemName: "folder.fill")
        case .settings:
            return Image(systemName: "person.fill")
        case .notification:
            return Image(systemName: "tray.circle.fill")
        }
    }

    var title: String {
        switch self {
        case .movies:
            return R.string.localizable.tabbarMovies()
        case .todos:
            return R.string.localizable.tabbarTodos()
        case .settings:
            return R.string.localizable.tabbarSettings()
        case .notification:
            return R.string.localizable.tabbarNotification()
        }
    }
}
