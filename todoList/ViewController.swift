//
//  ViewController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/06/13.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let controller = TodoItemController()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTodoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 読み込む
        self.controller.getTodoItem { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func todoItemAdded(_ sender: UITextField) {
        if let text = addTodoTextField.text, !text.isEmpty {
            let todo = TodoItem()
            todo.title = text
            self.controller.todoList.insert(todo, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
            
            // 保存する（追加）
            self.controller.addTodoItem(todoItem: todo)
        }
        
        addTodoTextField.text = nil
    }
    
    @IBAction func deletedItemsButtonTapped(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.controller.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todo = self.controller.todoList[indexPath.row]
        cell.textLabel?.text = todo.title
        
        if todo.isDone {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = self.controller.todoList[indexPath.row]
        
        if todo.isDone {
            todo.isDone = false
        } else {
            todo.isDone = true
        }
        
        // 保存する（更新）
        self.controller.updateTodoItem(todoItem: todo)
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let todo = self.controller.todoList[indexPath.row]
            todo.isDeleted = true
            self.controller.deletedTodoList.insert(todo, at: 0)
            self.controller.todoList.remove(at: indexPath.row)
            
            // 保存する（更新）
            self.controller.updateTodoItem(todoItem: todo)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! DeletedTodoViewController
        viewController.deletedTodoList = self.controller.deletedTodoList
    }
}

