//
//  ToDoItemViewModel.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 27.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItemViewModel {
    
    // MARK: - Properties
    
    private let realm = try! Realm()
    
    // MARK: - Functions
    
    public func saveToDoItem(name: String, description: String, startDate: TimeInterval, endDate: TimeInterval) {
        realm.beginWrite()
        let toDoItem = ToDoItem()
        toDoItem.itemName = name
        toDoItem.itemDescription = description
        toDoItem.startDate = startDate
        toDoItem.endDate = endDate
        realm.add(toDoItem)
        try! realm.commitWrite()
    }
    
    public func removeToDoItem(toDoItem: ToDoItem) {
        try! realm.write {
            realm.delete(toDoItem)
        }
    }
    
    public func toDoItems(forDate date: Date) -> [ToDoItem] {
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
    
    public func allToDoItems() -> [ToDoItem] {
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
