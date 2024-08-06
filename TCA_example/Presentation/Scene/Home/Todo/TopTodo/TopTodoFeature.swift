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
    @Injected(\.todoRepository) private var repository

    @ObservableState
    struct State {
        var todoLists: [TodoList] = []
    }

    enum Action {
        case load
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.todoLists = (try? repository.getTodoLists()) ?? []
                return .none
            }
        }
    }
}
