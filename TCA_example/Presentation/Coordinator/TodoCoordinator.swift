//
//  TodoCoordinator.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import SwiftUI
import ComposableArchitecture
import FlowStacks
import Factory

enum TodoSreenType {
    case topTodo(TopTodoScreen)
    case todoList(TodoListScreen)
    case addNewTodo(NewTodoScreen)
}

enum TodoFlowAction: NavigationAction {
    case initRoute
    case toTodoList(category: TodoCategory)
    case toAddNewTodo
    case close
    case pop
}

final class TodoCoordinatorViewModel: ObservableObject, CoordinatorViewModel {
    @Published var routes: Routes<TodoSreenType> = []
    @Injected(\.factory) private var factory
    private var todoStore: StoreOf<TodoFeature>!

    init() {
        todoStore = factory.todoStore.resolve()
        perform(.initRoute)
    }

    func perform(_ action: TodoFlowAction) {
        switch action {
        case .initRoute:
            let topTodoStore = todoStore.scope(state: \.topTodo, action: \.topTodo)
            routes = [.root(.topTodo(factory.topTodoScreen(topTodoStore)),
                            embedInNavigationView: true)]
        case .toTodoList(let category):
            let store = todoStore.scope(state: \.todoList, action: \.todoList)
            let params = (store, category)
            routes.push(.todoList(factory.todoListScreen(params)))
        case .toAddNewTodo:
            let screen = factory.addNewTodoScreen(todoStore.scope(state: \.newTodo, action: \.newTodo))
            routes.presentCover(.addNewTodo(screen),
                                embedInNavigationView: true)
        case .close:
            routes.dismiss()
        case .pop:
            routes.pop()
        }
    }
}

struct TodoCoordinator: View {
    @ObservedObject var viewModel: TodoCoordinatorViewModel

    var body: some View {
        Router($viewModel.routes) { screen in
            switch screen {
            case .topTodo(let screen):
                screen
            case .todoList(let screen):
                screen
            case .addNewTodo(let screen):
                screen
            }
        }
        .environmentObject(viewModel)
    }
}
