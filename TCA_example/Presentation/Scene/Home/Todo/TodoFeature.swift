//
//  CombineTodoFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 23/05/2024.
//

import ComposableArchitecture
import Factory
import Foundation

@Reducer
struct TodoFeature {
    let performNavigation: (TodoFlowAction) -> Void

    @ObservableState
    struct State {
        var topTodo: TopTodoFeature.State
        var newTodo: NewTodoFeature.State
        var todoList: TodoListFeature.State
    }

    enum Action {
        case topTodo(TopTodoFeature.Action)
        case newTodo(NewTodoFeature.Action)
        case todoList(TodoListFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.topTodo, action: /Action.topTodo) {
            TopTodoFeature(performNavigation: performNavigation)
        }
        Scope(state: \.newTodo, action: /Action.newTodo) {
            NewTodoFeature(performNavigation: performNavigation)
        }
        Scope(state: \.todoList, action: /Action.todoList) {
            TodoListFeature(performNavigation: performNavigation)
        }
        Reduce { _, action in
            switch action {
            case .newTodo(.todoAdded):
                return .run { send in
                    await send(.topTodo(.load))
                }
            default:
                return .none
            }
        }
    }
}
