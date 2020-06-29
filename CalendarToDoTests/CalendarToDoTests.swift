//
//  CalendarToDoTests.swift
//  CalendarToDoTests
//
//  Created by Valery Garaev on 27.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import XCTest
import RealmSwift
@testable import CalendarToDo

class CalendarToDoTests: XCTestCase {
    
    // MARK: - Properties
    
    let realmManager = RealmManager()
    let realm = try! Realm()
    
    let toDoItemForToday: ToDoItem = {
        let toDoItem = ToDoItem()
        toDoItem.itemName = "ToDo item for today"
        toDoItem.itemDescription = "ToDo item for today description"
        toDoItem.startDate = Date().timeIntervalSince1970
        toDoItem.endDate = Date(timeInterval: 3600, since: Date()).timeIntervalSince1970
        return toDoItem
    }()
    
    let toDoItemForTomorrow: ToDoItem = {
        let toDoItem = ToDoItem()
        toDoItem.itemName = "ToDo item for today"
        toDoItem.itemDescription = "ToDo item for today description"
        toDoItem.startDate = Date(timeInterval: 90000, since: Date()).timeIntervalSince1970
        toDoItem.endDate = Date(timeInterval: 3600, since: Date(timeIntervalSince1970: toDoItem.startDate)).timeIntervalSince1970
        return toDoItem
    }()
    
    // MARK: - Test functions

    func testSave() {
        realmManager.removeAllToDoItems()
        realmManager.save(toDoItem: toDoItemForToday)
        let allItems = realmManager.allToDoItems()
        XCTAssertEqual(toDoItemForToday, allItems[0])
        XCTAssertEqual(allItems.count, 1)
    }
    
    func testRemove() {
        realmManager.removeAllToDoItems()
        realmManager.save(toDoItem: toDoItemForToday)
        realmManager.save(toDoItem: toDoItemForTomorrow)
        realmManager.remove(toDoItem: toDoItemForToday)
        let allItems = realmManager.allToDoItems()
        XCTAssertEqual(allItems.count, 1)
    }
    
    func testRemoveAllToDoItems() {
        realmManager.save(toDoItem: toDoItemForToday)
        realmManager.save(toDoItem: toDoItemForTomorrow)
        realmManager.save(toDoItem: ToDoItem())
        realmManager.removeAllToDoItems()
        let allItems = realmManager.allToDoItems()
        XCTAssert(allItems.isEmpty)
    }
    
    func testUpdate() {
        realmManager.removeAllToDoItems()
        realmManager.save(toDoItem: toDoItemForToday)
        realm.beginWrite()
        toDoItemForToday.itemDescription = "Description has changed"
        try! realm.commitWrite()
        realmManager.update(toDoItem: toDoItemForToday)
        let toDoItem = realmManager.toDoItems(forDate: Date())
        XCTAssertEqual(toDoItem.count, 1)
        XCTAssertEqual(toDoItem[0].itemDescription, "Description has changed")
    }
    
    func testAddImage() {
        guard let image = UIImage(named: "voice_message") else { return }
        guard let imageData = image.pngData() else { return }
        XCTAssertNil(toDoItemForToday.image)
        realmManager.addImage(imageData, to: toDoItemForToday)
        XCTAssertNotNil(toDoItemForToday.image)
    }
    
    func testToDoItems() {
        realmManager.removeAllToDoItems()
        realmManager.save(toDoItem: toDoItemForToday)
        realmManager.save(toDoItem: toDoItemForTomorrow)
        let toDoItems = realmManager.toDoItems(forDate: Date())
        XCTAssertEqual(toDoItems.count, 1)
    }
    
    func testAllToDoItems() {
        realmManager.removeAllToDoItems()
        realmManager.save(toDoItem: toDoItemForToday)
        realmManager.save(toDoItem: toDoItemForTomorrow)
        var allItems = realmManager.allToDoItems()
        XCTAssertEqual(allItems.count, 2)
        realmManager.save(toDoItem: ToDoItem())
        allItems = realmManager.allToDoItems()
        XCTAssertEqual(allItems.count, 3)
    }

}
