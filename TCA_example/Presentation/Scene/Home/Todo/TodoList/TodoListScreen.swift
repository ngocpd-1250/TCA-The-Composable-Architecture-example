//
//  TodoListScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import SwiftUI
import ComposableArchitecture
import Factory

struct TodoListScreen: View {
    private var store: StoreOf<TodoListFeature>

    init(store: StoreOf<TodoListFeature>) {
        self.store = store
    }

    var body: some View {
        Screen(title: store.title) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    ForEach(store.todoItems) { item in
                        todoItem(item: item)
                            .onTapGesture {
                                store.send(.updateItemCompleted(item))
                            }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            store.send(.load)
        }
    }

    @ViewBuilder
    func todoItem(item: TodoItem) -> some View {
        HStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(formatDate(item.date))
                        .foregroundColor(Color(R.color.primary))
                        .strikethrough(item.isCompleted)

                    Text(item.name)
                        .fontWeight(.bold)
                        .foregroundColor(Color(R.color.labelPrimary))
                        .strikethrough(item.isCompleted)

                    Text(item.note)
                        .foregroundColor(Color(R.color.labelPrimary))
                        .strikethrough(item.isCompleted)
                }
            }
            Spacer()
            VStack {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(item.isCompleted ? Color(R.color.primary) : .gray)
                    .font(.system(size: 25))

                Spacer()
                    .frame(height: Spacing.small.value)

                Button(R.string.localizable.commonDelete()) {
                    store.send(.deleteItem(item))
                }
                .tint(Color(R.color.primary))
            }
        }
        .padding()
        .background(Color(R.color.todoCardBackground))
        .cornerRadius(10)
    }
}

struct TodoListScreen_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: TodoListFeature.State()) {
            TodoListFeature()
        }
        return Container.shared.todoListScreen((store, TodoCategory.all))
    }
}
