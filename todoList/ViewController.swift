//
//  ViewController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/06/13.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var todoList = [TodoController]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(with: storedTodoList) as? [TodoController] {
                todoList.append(contentsOf: unarchiveTodoList)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "追加", message: "入力してください", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                let todo = TodoController()
                todo.todoTitle = textField.text!
                self.todoList.insert(todo, at:0)
                
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
                
                let userDefaults = UserDefaults.standard
                let data = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
                userDefaults.set(data, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        alertController.addAction(okAction)
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        present(alertController,animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todo = todoList[indexPath.row]
        cell.textLabel?.text = todo.todoTitle
        
        if todo.todoDone {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todoList[indexPath.row]
        
        if todo.todoDone {
            todo.todoDone = false
        } else {
            todo.todoDone = true
        }
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
            let userDefaults = UserDefaults.standard
            
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        }
    }

}

