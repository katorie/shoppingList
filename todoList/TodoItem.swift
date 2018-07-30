//
//  TodoController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/06/15.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import Foundation

class TodoItem: NSObject {
    var title: String = ""
    var isDone: Bool = false
    var isDeleted: Bool = false
    var documentID: String = ""
    
    override init() {
    }
}
