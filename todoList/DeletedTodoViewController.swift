//
//  DeletedTodoViewController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/06/25.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import UIKit

class DeletedTodoViewController: UITableViewController {
    var deletedTodoList = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deletedTodoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deletedTodoCell", for: indexPath)
        let todo = deletedTodoList[indexPath.row]
        cell.textLabel?.text = todo.title
        
        return cell
    }

}
