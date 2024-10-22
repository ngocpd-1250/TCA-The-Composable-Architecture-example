//
//  TopTodoScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import SwiftUI
import Defaults
import ComposableArchitecture
import Factory

struct TopTodoScreen: View {
    @Bindable var store: StoreOf<TopTodoFeature>
    @EnvironmentObject var coordinator: TodoCoordinatorViewModel

    init(store: StoreOf<TopTodoFeature>) {
        self.store = store
    }

    var body: some View {
        Screen(localizeTitleResource: R.string.localizable.todoTitle) {
            ZStack {
                if store.todoLists.isEmpty {
                    emptyView()
                } else {
                    todoListView(todoLists: store.todoLists)
                }
                addNewButton()
            }
        }
        .onAppear {
            store.send(.load)
        }
    }

    @ViewBuilder
    func todoListView(todoLists: [TodoList]) -> some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 200),
                                             spacing: Spacing.normal.value)],
                          content: {
                              ForEach(todoLists, id: \.category.id) { item in
                                  TodoListItem(todoList: item)
                                      .onTapGesture {
                                          coordinator.perform(.toTodoList(category: item.category))
                                      }
                              }
                          })
                          .id(Defaults[.language])
                Spacer()
            }
            .padding()
        }
    }

    @ViewBuilder
    func emptyView() -> some View {
        Image(R.image.todos_empty)
            .resizable()
            .frame(width: 200, height: 200, alignment: .center)
            .padding(.bottom, 40)
    }

    @ViewBuilder
    func addNewButton() -> some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button(action: {
                    coordinator.perform(.toAddNewTodo)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding()
                        .tint(Color(R.color.primary))
                })
            }
        }
    }
}

struct TopTodoScreen_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: TopTodoFeature.State()) {
            TopTodoFeature()
        }
        return Container.shared.topTodoScreen(store)
    }
}
