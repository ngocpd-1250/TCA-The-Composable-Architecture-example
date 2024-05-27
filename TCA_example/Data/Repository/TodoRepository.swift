//
//  TodoRepository.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import Foundation
import Factory
import SwiftData

protocol TodoRepository {
    func getTodoLists() throws -> [TodoList]
    func getTodos(category: TodoCategory) throws -> [TodoItem]
    func addTodo(name: String, date: Date, note: String, category: TodoCategory) throws
    func deleteTodo(item: TodoItem) throws
    func updateCompleted(item: TodoItem)
}

struct TodosRepositoryImpl: TodoRepository {
    @Injected(\.modelContext) private var modelContext

    func getTodoLists() throws -> [TodoList] {
        let descriptor = FetchDescriptor<TodoItem>()
        let todoItems = try modelContext?.fetch(descriptor) ?? []
        return groupTodoItemsToTodoLists(items: todoItems)
    }

    func getTodos(category: TodoCategory) throws -> [TodoItem] {
        let descriptor = FetchDescriptor<TodoItem>(predicate: #Predicate {
            $0.categoryId == category.id
        })
        let items = try modelContext?.fetch(descriptor) ?? []
        return items
    }

    func addTodo(name: String, date: Date, note: String, category: TodoCategory) throws {
        let item = TodoItem(name: name, note: note, categoryId: category.id, date: date)
        modelContext?.insert(item)
        try modelContext?.save()
    }

    func deleteTodo(item: TodoItem) throws {
        modelContext?.delete(item)
        try modelContext?.save()
    }

    func updateCompleted(item: TodoItem) {
        item.isCompleted.toggle()
    }

    private func groupTodoItemsToTodoLists(items: [TodoItem]) -> [TodoList] {
        var dict: [TodoCategory: TodoList] = [:]

        for todoItem in items {
            dict[TodoCategory.byId(todoItem.categoryId), default: TodoList(category: TodoCategory.byId(todoItem.categoryId))].items.append(todoItem)
        }

        return Array(dict.values).sorted(by: { $0.category.name < $1.category.name })
    }
}
