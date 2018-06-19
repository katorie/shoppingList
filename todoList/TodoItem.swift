//
//  TodoController.swift
//  todoList
//
//  Created by 加藤理絵 on 2018/06/15.
//  Copyright © 2018年 Rie Kato. All rights reserved.
//

import Foundation

class TodoItem: NSObject, NSCoding {
    var title: String?
    var isDone: Bool = false
    var isDeleted: Bool = false
    
    override init() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        isDone = aDecoder.decodeBool(forKey: "isDone")
        isDeleted = aDecoder.decodeBool(forKey: "isDeleted")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(isDone, forKey: "isDone")
        aCoder.encode(isDone, forKey: "isDeleted")
    }
}
