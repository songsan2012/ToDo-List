//
//  ToDoItem.swift
//  ToDo List
//
//  Created by song on 1/13/22.
//  Copyright © 2022 song. All rights reserved.
//

import Foundation

struct ToDoItem : Codable{
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    
    var completed: Bool
}
