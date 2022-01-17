//
//  ViewController.swift
//  ToDo List
//
//  Created by song on 1/10/22.
//  Copyright © 2022 song. All rights reserved.
//

import UIKit
import UserNotifications

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var AddBarButton: UIBarButtonItem!
    @IBOutlet weak var EditBarButton: UIBarButtonItem!
    
//    var toDoArray = ["Learn Swift", "Publish App", "Change the world", "Take a vacation"]
    
//    var toDoItems: [ToDoItem] = []
    var toDoItems = ToDoItems()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        LoadData()
//        toDoItems.loadData()
        toDoItems.loadData {
            self.tableView.reloadData()
        }
        
        authorizeLocalNotification()
    }

    func authorizeLocalNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // -- If there is an error, kick out and handle error
            guard error == nil else {
                print("😡 ERROR: \(error!.localizedDescription)")
                return
            }
            
            // -- If granted
            if granted {
                print("✅ Notifications Authorization Granted!")
                // TODO: Look into what else to do when authorized.
            }
            else {
                print("🚫 The user has denied notifications!")
                
                //TODO: Put an alert in here telling the user what to do
                
            }
            
            
        }
    }
    
        func setNotifications() {
            
            guard toDoItems.itemsArray.count > 0 else {
                return
            }
            
            // remove all notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            // -- Loop to update data
            for index in 0..<toDoItems.itemsArray.count {
                if toDoItems.itemsArray[index].reminderSet {
                    let toDoItem = toDoItems.itemsArray[index]
                    
                    toDoItems.itemsArray[index].notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
                }
            }
            
            
        }
    
    
        func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound, date: Date) -> String {
            
            // -- Create Content:
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.body = body
            content.sound = sound
            content.badge = badgeNumber
            
            // -- Create trigger
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            dateComponents.second = 00
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            
            // -- Create request
            let notificationID = UUID().uuidString
            let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
            
            // -- Register request with the notification center
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("😡 ERROR: \(error.localizedDescription) Yikes, adding notification request went wrong!")
                }
                else {
                    print("Notification schedule \(notificationID), title: \(content.title)")
                }
            }
            
            return notificationID
            
        }
    
    
    
    // -- To Load Data to iOS - Start
//        func LoadData() {
//             let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//             let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
//
//            guard let data = try? Data(contentsOf: documentURL) else { return }
//
//            let jsonDecoder = JSONDecoder()
//
//            do {
//                toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
//                tableView.reloadData()
//            }  catch {
//                print("😡 ERROR: Could not LOAD data \(error.localizedDescription)")
//            }
//
//        }
    
    // -- To Load Data to iOS - End
    
    
    // -- To Save Data to iOS - Start
        func saveData() {
//            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
//            
//            let jsonEncoder = JSONEncoder()
//            let data = try? jsonEncoder.encode(toDoItems)
//            
//            do {
//                try data?.write(to: documentURL, options: .noFileProtection)
//            } catch {
//                print("😡 ERROR: Could not SAVE data \(error.localizedDescription)")
//            }
            
//            let toDoItem = toDoItems.first!
//            let notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "Subtitle would go here", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            
            toDoItems.saveData()
            
            setNotifications()
            
        }
    // -- To Save Data to iOS - End
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            
//            destination.todoItem = toDoArray[selectedIndexPath.row]
            destination.todoItem = toDoItems.itemsArray[selectedIndexPath.row]
        }
        else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
                
            }
            
            
        }
        
    }
    
    // -- Coming back from other Navigation Window - Start
        @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
            let source = segue.source as! ToDoDetailTableViewController
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                toDoItems.itemsArray[selectedIndexPath.row] = source.todoItem
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDoItems.itemsArray.count, section: 0)
                toDoItems.itemsArray.append(source.todoItem)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
            }
            
            saveData()
        }
    // -- Coming back from other Navigation Window - End
    
    
    // -- Editing items - Start
        @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
            if tableView.isEditing {
                tableView.setEditing(false, animated: true)
                sender.title = "Edit"
                AddBarButton.isEnabled = true
            }
            else {
                tableView.setEditing(true, animated: true)
                sender.title = "Done"
                AddBarButton.isEnabled = false
                
            }
            
        }
    
    // -- Editing items - End
    
    
    
    
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            toDoItems.itemsArray[selectedIndexPath.row].completed = !toDoItems.itemsArray[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            
            saveData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return toDoItems.count
        return toDoItems.itemsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
//        cell.textLabel?.text = toDoItems[indexPath.row].name
        
//        cell.nameLabel.text = toDoItems[indexPath.row].name
//        cell.checkboxButton.isSelected =  toDoItems[indexPath.row].completed
        cell.toDoItem = toDoItems.itemsArray[indexPath.row]

        return cell
    }
    
    // -- Edit row functionality - Start
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                toDoItems.itemsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                saveData()
            }
            
        }
    // -- Edit row funcationlity - End
    
    
    // -- Move row functionality - Start
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            
            let itemToMove = toDoItems.itemsArray[sourceIndexPath.row]
            toDoItems.itemsArray.remove(at: sourceIndexPath.row)
            toDoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
            saveData()
        }
    
    // -- Move row functionality - End
    
    
}

