//
//  TodoItemController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/08/17.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import Foundation

class TodoItemController {
    var todoList = [TodoItem]()
    var deletedTodoList = [TodoItem]()
    
    let dataStore = DataStore()
    
    func getTodoItem(completion: @escaping () -> Void) {
        self.dataStore.getTodoItem { [weak self] error in
            // TODO errorどうするか決める
            if let documents = self?.dataStore.documents {
                for document in documents {
                    guard let data = document.data() else {
                        continue
                    }
                    let todo = TodoItem()
                    todo.documentID = document.documentID

                    // todo.title = (data["title"] as? String) ?? ""
                    if let title = data["title"] as? String {
                        todo.title = title
                    } else {
                        todo.title = ""
                    }

                    if let isDeleted = data["isDeleted"] as? Bool {
                        todo.isDeleted = isDeleted
                    } else {
                        todo.isDeleted = false
                    }
                    
                    if let isDone = data["isDone"] as? Bool {
                        todo.isDone = isDone
                    } else {
                        todo.isDone = false
                    }
                    
                    if todo.isDeleted {
                        self?.deletedTodoList.append(todo)
                    } else {
                        self?.todoList.append(todo)
                    }
                }
                completion()
            }
        }
    }
    
    func addTodoItem(title: String) {
        let todo = TodoItem()
        todo.title = title
        self.todoList.insert(todo, at: 0)
        
        // 保存する（追加）
        self.dataStore.addTodoItem(todoItem: todo)
    }
    
    func updateTodoItemIsDone(index: Int) {
        let todo = self.todoList[index]
        
        if todo.isDone {
            todo.isDone = false
        } else {
            todo.isDone = true
        }
        
        // 保存する（更新）
        self.dataStore.updateTodoItem(todoItem: todo)
    }
    
    func updateTodoItemIsDeleted(index: Int) {
        let todo = self.todoList[index]
        todo.isDeleted = true
        self.deletedTodoList.insert(todo, at: 0)
        self.todoList.remove(at: index)
        
        // 保存する（更新）
        self.dataStore.updateTodoItem(todoItem: todo)

    }
}
