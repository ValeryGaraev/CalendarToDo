//
//  Constants.swift
//  CalendarToDo
//
//  Created by Valery Garaev on 29.06.2020.
//  Copyright © 2020 Valery Garaev. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let TODOITEMS_REF = DB_REF.child("toDoItems")
let STORAGE_REF = Storage.storage().reference()
let STORAGE_IMAGES = STORAGE_REF.child("images")
