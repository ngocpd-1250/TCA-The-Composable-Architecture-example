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
    var todoStore: Factory<StoreOf<TodoFeature>> {
        self {
            Store(initialState: TodoFeature.State(topTodo: TopTodoFeature.State(),
                                                  newTodo: NewTodoFeature.State(),
                                                  todoList: TodoListFeature.State())) {
                TodoFeature()
            }
        }
    }
}
