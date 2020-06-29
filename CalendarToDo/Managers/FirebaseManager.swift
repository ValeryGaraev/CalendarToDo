//
//  FirebaseManager.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 29.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    // MARK: - Properties
    
    static let shared = FirebaseManager()
    
    // MARK: - Functions
    
    public final func save(toDoItem: ToDoItem, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard Reachability.shared.checkConnection() else { return }
        
        let fileName = toDoItem.id
        let storageReference = STORAGE_IMAGES.child(fileName)
        
        if let imageData = toDoItem.image {
            storageReference.putData(imageData, metadata: nil) { (storageMetaData, error) in
                storageReference.downloadURL { (url, error) in
                    guard let imageUrlString = url?.absoluteString else { return }
                    let values = ["name": toDoItem.itemName,
                                  "description": toDoItem.itemDescription,
                                  "startDate": toDoItem.startDate,
                                  "endDate": toDoItem.endDate,
                                  "imageURL": imageUrlString] as [String : Any]
                    TODOITEMS_REF.child(toDoItem.id).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        } else {
            storageReference.downloadURL { (url, error) in
                let values = ["name": toDoItem.itemName,
                              "description": toDoItem.itemDescription,
                              "startDate": toDoItem.startDate,
                              "endDate": toDoItem.endDate] as [String : Any]
                TODOITEMS_REF.child(toDoItem.id).updateChildValues(values, withCompletionBlock: completion)
            }
        }
    }
    
    public final func remove(toDoItem: ToDoItem) {
        guard Reachability.shared.checkConnection() else { return }
        if toDoItem.image != nil {
            let storageReference = STORAGE_IMAGES.child(toDoItem.id)
            storageReference.delete(completion: nil)
            TODOITEMS_REF.child(toDoItem.id).removeValue()
        } else {
            TODOITEMS_REF.child(toDoItem.id).removeValue()
        }
    }
}
