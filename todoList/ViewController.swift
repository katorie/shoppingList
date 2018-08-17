//
//  ViewController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/06/13.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todoList = [TodoItem]()
    var deletedTodoList = [TodoItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTodoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 読み込む
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

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
                strongSelf.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func todoItemAdded(_ sender: UITextField) {
        if let text = addTodoTextField.text, !text.isEmpty {
            let todo = TodoItem()
            todo.title = text
            self.todoList.insert(todo, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
            
            // 保存する
            let db = Firestore.firestore()
            
            var ref: DocumentReference? = nil
            ref = db.collection("todoItems").addDocument(data: [
                "title": todo.title,
                "isDeleted": todo.isDeleted,
                "isDone": todo.isDone
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            if let documentID = ref?.documentID {
                todo.documentID = documentID
            }
        }
        
        addTodoTextField.text = nil
    }
    
    @IBAction func deletedItemsButtonTapped(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todo = todoList[indexPath.row]
        cell.textLabel?.text = todo.title
        
        if todo.isDone {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todoList[indexPath.row]
        
        if todo.isDone {
            todo.isDone = false
        } else {
            todo.isDone = true
        }
        
        // 保存する
        let db = Firestore.firestore()
        
        let todoItemRef = db.collection("todoItems").document(todo.documentID)
        todoItemRef.updateData(["isDone": todo.isDone])
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let todo = todoList[indexPath.row]
            todo.isDeleted = true
            deletedTodoList.insert(todo, at: 0)
            todoList.remove(at: indexPath.row)
            
            // 保存する
            let db = Firestore.firestore()
            
            let todoItemRef = db.collection("todoItems").document(todo.documentID)
            todoItemRef.updateData(["isDeleted": todo.isDeleted])
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! DeletedTodoViewController
        viewController.deletedTodoList = self.deletedTodoList
    }
}

