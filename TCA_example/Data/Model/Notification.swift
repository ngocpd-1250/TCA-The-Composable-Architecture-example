//
//  Notification.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 30/05/2024.
//

import Foundation

enum NotificationType: String, CaseIterable, Identifiable {
    var id: Self {
        self
    }

    case movie
    case todo
    case settings

    var buttonTitle: String {
        switch self {
        case .movie:
            return "Let's send a movie notification"
        case .todo:
            return "Let's send a todo notification"
        case .settings:
            return "Let's send a settings notification"
        }
    }

    var body: String {
        switch self {
        case .movie:
            return "Move to movie detail"
        case .todo:
            return "Let's add a new todo"
        case .settings:
            return "Set up your favorite settings"
        }
    }
}
