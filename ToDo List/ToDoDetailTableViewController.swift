//
//  ToDoDetailTableViewController.swift
//  ToDo List
//
//  Created by song on 1/12/22.
//  Copyright © 2022 song. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    print("📆 I JUST CREATED A DATE FORMATTER!")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class ToDoDetailTableViewController: UITableViewController {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var todoDatePicker: UIDatePicker!
    @IBOutlet weak var todoNotes: UITextView!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    

    var todoItem: ToDoItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if todoItem == nil {
            todoItem = ToDoItem(name: "", date: Date(), notes: "", reminderSet: false)
        }

        updateUserInterface()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        todoItem = nameField.text
//        todoItem = ToDoItem(name: nameField.text!, date: todoDatePicker.date, notes: todoNotes.text)
        todoItem = ToDoItem(name: nameField.text!, date: todoDatePicker.date, notes: todoNotes.text, reminderSet: reminderSwitch.isOn)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentinginAddMode = presentingViewController is UINavigationController
        
        if isPresentinginAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    
    
    }
    
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        
        if reminderSwitch.isOn {
            dateLabel.textColor = .black
        }
        else {
            dateLabel.textColor = .gray
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    func updateUserInterface() {
         nameField.text = todoItem.name
         todoDatePicker.date = todoItem.date
         todoNotes.text = todoItem.notes
         reminderSwitch.isOn = todoItem.reminderSet
         
         if reminderSwitch.isOn {
             dateLabel.textColor = .black
         }
         else {
             dateLabel.textColor = .gray
         }
        
        dateLabel.text = dateFormatter.string(from: todoItem.date)
     }
    
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = dateFormatter.string(from: sender.date)
        
        
    }
    
    
}


extension ToDoDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? todoDatePicker.frame.height : 0
        case notesTextViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}
