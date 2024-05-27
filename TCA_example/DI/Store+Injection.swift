//
//  Store+Injection.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 30/05/2024.
//

import Foundation
import Factory
import ComposableArchitecture

extension Container {
    var todoStore: ParameterFactory<(TodoFlowAction) -> Void, StoreOf<TodoFeature>> {
        self { performNavigation in
            Store(initialState: TodoFeature.State(topTodo: TopTodoFeature.State(),
                                                  newTodo: NewTodoFeature.State(),
                                                  todoList: TodoListFeature.State())) {
                TodoFeature(performNavigation: performNavigation)
            }
        }
    }
}
