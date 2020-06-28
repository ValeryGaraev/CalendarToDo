//
//  ToDoItem.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 27.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var itemName: String = ""
    @objc dynamic var itemDescription: String = ""
    @objc dynamic var startDate: TimeInterval = 0.0
    @objc dynamic var endDate: TimeInterval = 0.0
    @objc dynamic var image: Data = Data()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
