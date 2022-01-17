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
        
        toDoItems.loadData {
            self.tableView.reloadData()
        }
        
        LocalNotificationManager.authorizeLocalNotification(viewController: self)
    }
    
    
    
    // -- To Save Data to iOS - Start
        func saveData() {
            toDoItems.saveData()
            
//            setNotifications()
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

