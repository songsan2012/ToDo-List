//
//  ViewController.swift
//  ToDo List
//
//  Created by song on 1/10/22.
//  Copyright © 2022 song. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController {
    

    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var AddBarButton: UIBarButtonItem!
    @IBOutlet weak var EditBarButton: UIBarButtonItem!
    
//    var toDoArray = ["Learn Swift", "Publish App", "Change the world", "Take a vacation"]
    
    var toDoItems: [ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        LoadData()
    }

    // -- To Load Data to iOS - Start
        func LoadData() {
             let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
             let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
             
            guard let data = try? Data(contentsOf: documentURL) else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
                tableView.reloadData()
            }  catch {
                print("😡 ERROR: Could not LOAD data \(error.localizedDescription)")
            }
            
        }
    
    // -- To Load Data to iOS - End
    
    
    // -- To Save Data to iOS - Start
        func saveData() {
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
            
            let jsonEncoder = JSONEncoder()
            let data = try? jsonEncoder.encode(toDoItems)
            
            do {
                try data?.write(to: documentURL, options: .noFileProtection)
            } catch {
                print("😡 ERROR: Could not SAVE data \(error.localizedDescription)")
            }
            
        }
    // -- To Save Data to iOS - End
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            
//            destination.todoItem = toDoArray[selectedIndexPath.row]
            destination.todoItem = toDoItems[selectedIndexPath.row]
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
                toDoItems[selectedIndexPath.row] = source.todoItem
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
                toDoItems.append(source.todoItem)
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

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("🤭 Number of rows in section: \(toDoItems.count)")
        
        //        return toDoArray.count
        return toDoItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row].name
        print("Cell at rowpath just called at \(cell)")
        return cell
    }
    
    // -- Edit row functionality - Start
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == .delete {
                toDoItems.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                saveData()
            }
            
        }
    // -- Edit row funcationlity - End
    
    
    // -- Move row functionality - Start
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            
            let itemToMove = toDoItems[sourceIndexPath.row]
            toDoItems.remove(at: sourceIndexPath.row)
            toDoItems.insert(itemToMove, at: destinationIndexPath.row)
            saveData()
        }
    
    // -- Move row functionality - End
    
    
}

