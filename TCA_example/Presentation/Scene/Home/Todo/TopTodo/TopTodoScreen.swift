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
    private var store: StoreOf<TopTodoFeature>

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
                                          store.send(.toListTodo(item.category))
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
                    store.send(.toAddNew)
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
        let perform: (TodoFlowAction) -> Void = { _ in
        }
        let store = Store(initialState: TopTodoFeature.State()) {
            TopTodoFeature(performNavigation: perform)
        }
        return Container.shared.topTodoScreen(store)
    }
}
