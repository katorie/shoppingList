//
//  TodoItemController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/08/17.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class TodoItemController {
    var todoList = [TodoItem]()
    var deletedTodoList = [TodoItem]()
    
    init() {
        FirebaseApp.configure()

        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getTodoItem(completion: @escaping ()->Void) {
        let db = Firestore.firestore()
        
        db.collection("todoItems").getDocuments() { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let strongSelf = self else {
                    return
                }
                
                for document in querySnapshot!.documents {
                    let todo = TodoItem()
                    todo.documentID = document.documentID
                    todo.title = document.data()["title"] as! String
                    todo.isDeleted = document.data()["isDeleted"] as! Bool
                    todo.isDone = document.data()["isDone"] as! Bool
                    
                    if todo.isDeleted {
                        strongSelf.deletedTodoList.append(todo)
                    } else {
                        strongSelf.todoList.append(todo)
                    }
                }
                completion()
            }
        }
    }
    
    func addTodoItem(todoItem: TodoItem) {
        let db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        ref = db.collection("todoItems").addDocument(data: [
            "title": todoItem.title,
            "isDeleted": todoItem.isDeleted,
            "isDone": todoItem.isDone
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        if let documentID = ref?.documentID {
            todoItem.documentID = documentID
        }
    }
    
    func updateTodoItem(todoItem: TodoItem, status: String) {
        let db = Firestore.firestore()
        let todoItemRef = db.collection("todoItems").document(todoItem.documentID)

        if status == "isDone" {
            todoItemRef.updateData([status: todoItem.isDone])
        } else if status == "isDeleted" {
            todoItemRef.updateData([status: todoItem.isDeleted])
        }
    }
}
