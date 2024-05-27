//
//  TopTodoFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct TopTodoFeature {
    let performNavigation: (TodoFlowAction) -> Void
    @Injected(\.todoRepository) private var repository

    @ObservableState
    struct State {
        var todoLists: [TodoList] = []
    }

    enum Action {
        case load
        case toAddNew
        case toListTodo(TodoCategory)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.todoLists = (try? repository.getTodoLists()) ?? []
                return .none

            case .toAddNew:
                performNavigation(.toAddNewTodo)
                return .none

            case .toListTodo(let category):
                performNavigation(.toTodoList(category: category))
                return .none
            }
        }
    }
}
