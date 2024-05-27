//
//  TodoListFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 23/05/2024.
//

import ComposableArchitecture
import Factory

@Reducer
struct TodoListFeature {
    let performNavigation: (TodoFlowAction) -> Void
    @Injected(\.todoRepository) private var repository

    @ObservableState
    struct State {
        var category: TodoCategory!
        var title = ""
        var todoItems: [TodoItem] = []
    }

    enum Action {
        case setCategory(TodoCategory)
        case load
        case updateItemCompleted(TodoItem)
        case deleteItem(TodoItem)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setCategory(let category):
                state.category = category
                return .none
            case .load:
                state.title = state.category.name
                state.todoItems = (try? repository.getTodos(category: state.category)) ?? []
                return .none
            case .updateItemCompleted(let item):
                repository.updateCompleted(item: item)
                return .none
            case .deleteItem(let item):
                try? repository.deleteTodo(item: item)
                state.todoItems = (try? repository.getTodos(category: state.category)) ?? []
                if state.todoItems.isEmpty {
                    performNavigation(.pop)
                }
                return .none
            }
        }
    }
}
