//
//  DataStore.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/08/23.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class DataStore {
    var documents = [DocumentSnapshot]()
    
    init() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getTodoItem(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("todoItems").getDocuments() { (querySnapshot, err) in
            self.documents = querySnapshot!.documents
            completion(err)
        }
    }
    
    func addTodoItem(todoItem: TodoItem) {
        let db = Firestore.firestore()
        
        let ref = db.collection("todoItems").addDocument(data: [
            "title": todoItem.title,
            "isDeleted": todoItem.isDeleted,
            "isDone": todoItem.isDone
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
        }
        
        todoItem.documentID = ref.documentID
    }
    
    func updateTodoItem(todoItem: TodoItem) {
        let db = Firestore.firestore()
        let todoItemRef = db.collection("todoItems").document(todoItem.documentID)
        todoItemRef.updateData(["isDone": todoItem.isDone, "isDeleted": todoItem.isDeleted])
    }
}
