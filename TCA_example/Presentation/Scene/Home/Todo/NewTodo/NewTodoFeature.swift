//
//  NewTodoFeature.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import ComposableArchitecture
import Factory
import Foundation

@Reducer
struct NewTodoFeature {
    let performNavigation: (TodoFlowAction) -> Void
    @Injected(\.todoRepository) private var repository

    @ObservableState
    struct State {
        var note = ""
        var selectedDate = Date()
        var name = ""
        var category = TodoCategory.all
        var isShowValidationError = false
    }

    enum Action {
        case add
        case todoAdded
        case close
        case selectedDateChanged(Date)
        case noteChanged(String)
        case nameChanged(String)
        case selectCategory(TodoCategory)
        case setValidationError(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .add:
                var isValidInput: Bool {
                    return !state.name.isEmpty && !state.note.isEmpty
                }
                if isValidInput {
                    try? repository.addTodo(name: state.name,
                                            date: state.selectedDate,
                                            note: state.note,
                                            category: state.category)
                    return .run { send in
                        await send(.todoAdded)
                    }
                } else {
                    state.isShowValidationError = true
                    return .none
                }

            case .todoAdded:
                performNavigation(.close)
                state = NewTodoFeature.State()
                return .none

            case .close:
                performNavigation(.close)
                state = NewTodoFeature.State()
                return .none

            case .selectedDateChanged(let date):
                state.selectedDate = date
                return .none

            case .noteChanged(let note):
                state.note = note
                return .none

            case .nameChanged(let name):
                state.name = name
                return .none

            case .selectCategory(let category):
                state.category = category
                return .none

            case .setValidationError(let value):
                state.isShowValidationError = value
                return .none
            }
        }
    }
}