//
//  TodoController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/06/15.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import Foundation

class TodoController: NSObject, NSCoding {
    var todoTitle: String?
    var todoDone: Bool = false
    
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
}
