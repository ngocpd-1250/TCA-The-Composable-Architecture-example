//
//  NewTodoScreen.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import SwiftUI
import ComposableArchitecture
import Factory

struct NewTodoScreen: View {
    @Bindable var store: StoreOf<NewTodoFeature>
    @EnvironmentObject var coordinator: TodoCoordinatorViewModel

    init(store: StoreOf<NewTodoFeature>) {
        self.store = store
    }

    var body: some View {
        Screen {
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: Spacing.normal.value)

                    header()

                    Spacer()
                        .frame(height: Spacing.normal.value)

                    noteInput()

                    Spacer()
                        .frame(height: Spacing.normal.value)

                    dateSeletion()

                    Spacer()
                        .frame(height: Spacing.normal.value)

                    nameInput()

                    Spacer()
                        .frame(height: Spacing.normal.value)

                    selectCategory()

                    categoryView()

                    Spacer()
                        .frame(height: Spacing.normal.value)

                    addButton()
                }
                .padding(.horizontal, Spacing.normal.value)
            }
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .alert(isPresented: $store.isShowValidationError.sending(\.setValidationError)) {
            Alert(title: Text("Error"),
                  message: Text(R.string.localizable.validationTodoItemInvalid()),
                  dismissButton: .default(Text("OK")))
        }
        .onChange(of: store.isClose) { _, newValue in
            guard newValue else {
                return
            }
            coordinator.perform(.close)
        }
    }

    @ViewBuilder
    func header() -> some View {
        HStack {
            Spacer()

            Text(R.string.localizable.commonNewTodo())
                .fontWeight(.medium)
                .padding(.leading, 30)
                .foregroundColor(Color(R.color.labelPrimary))

            Spacer()

            Button(action: {
                store.send(.close)
            }, label: {
                Image(systemName: "xmark")
                    .tint(Color(R.color.backButtonPrimary))
            })
        }
    }

    @ViewBuilder
    func noteInput() -> some View {
        VStack(alignment: .leading) {
            Text(R.string.localizable.todoPlanning())
                .frame(height: 10, alignment: .leading)
                .foregroundColor(.gray)

            Spacer()
                .frame(height: Spacing.normal.value)

            TextEditor(text: $store.note.sending(\.noteChanged))
                .frame(height: 150, alignment: .leading)
                .scrollContentBackground(.hidden)
                .background(Color(R.color.todoCardBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    @ViewBuilder
    func dateSeletion() -> some View {
        HStack {
            Image(systemName: "bell.badge")
                .foregroundColor(.gray)
                .frame(width: 30, height: 30, alignment: .leading)

            VStack {
                DatePicker(R.string.localizable.todoSelectDate(),
                           selection: $store.selectedDate.sending(\.selectedDateChanged))
                    .labelsHidden()
                    .tint(Color(R.color.primary))
            }

            Spacer()
        }
    }

    @ViewBuilder
    func nameInput() -> some View {
        HStack {
            Image(systemName: "square.and.pencil")
                .foregroundColor(.gray)
                .frame(width: 30, height: 30, alignment: .leading)

            TextField(R.string.localizable.todoName(), text: $store.name.sending(\.nameChanged))
                .frame(height: 40)
        }
    }

    @ViewBuilder
    func selectCategory() -> some View {
        HStack {
            Image(systemName: "tag")
                .foregroundColor(.gray)
                .frame(width: 30, height: 30, alignment: .leading)

            VStack {
                Text(store.category.name)
                    .foregroundColor(Color(R.color.labelPrimary))
            }

            Spacer()
        }
    }

    @ViewBuilder
    func categoryView() -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 10)], content: {
                ForEach(TodoCategory.allCases) { category in
                    HStack {
                        Image(category.image)
                            .resizable()
                            .frame(width: 20, height: 20)

                        Text(category.name)
                            .font(.callout)
                            .fontWeight(.regular)

                        Spacer()
                    }
                    .padding(.leading, Spacing.small.value)
                    .onTapGesture {
                        store.send(.selectCategory(category))
                    }
                    .frame(width: 120, height: 30)
                    .background(category == store.category ? Color(R.color.todoCardBackground) : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            })
        }
    }

    @ViewBuilder
    func addButton() -> some View {
        BaseButton(title: R.string.localizable.todoAdd()) {
            store.send(.add)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .padding(.top, Spacing.normal.value)
    }
}

struct NewTodoScreen_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(initialState: NewTodoFeature.State()) {
            NewTodoFeature()
        }
        return Container.shared.addNewTodoScreen(store)
    }
}
