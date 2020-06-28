//
//  RealmManager.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 27.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    // MARK: - Properties
    
    private let realm = try! Realm()
    
    // MARK: - Functions
    
    public final func save(toDoItem: ToDoItem) {
        try! realm.write {
            realm.add(toDoItem)
        }
    }
    
    public final func remove(toDoItem: ToDoItem) {
        try! realm.write {
            realm.delete(toDoItem)
        }
    }
    
    public final func update(toDoItem: ToDoItem) {
        try! realm.write {
            realm.add(toDoItem, update: Realm.UpdatePolicy.modified)
        }
    }
    
    public final func addImage(_ image: Data, to toDoItem: ToDoItem) {
        try! realm.write {
            toDoItem.image = image
        }
    }
    
    public final func toDoItems(forDate date: Date) -> [ToDoItem] {
        let allItems = allToDoItems()
        let calendar = Calendar.current
        let selectedDate = calendar.dateComponents([.year, .month, .day], from: date)
        var toDoItems = [ToDoItem]()
        for toDoItem in allItems {
            let itemDate = calendar.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: toDoItem.startDate))
            if itemDate == selectedDate {
                toDoItems.append(toDoItem)
            }
        }
        toDoItems.sort { $0.startDate < $1.startDate }
        return toDoItems
    }
    
    private func allToDoItems() -> [ToDoItem] {
        return realm.objects(ToDoItem.self).toArray(ofType: ToDoItem.self) as [ToDoItem]
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
