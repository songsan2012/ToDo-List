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

class ToDoDetailTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    

    var todoItem: ToDoItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // -- Hide the keyboard if we tap outside of a view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        nameField.delegate = self
        
        if todoItem == nil {
            todoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
            nameField.becomeFirstResponder()
        }
        
        
        updateUserInterface()
    }
    
    func updateUserInterface() {
         nameField.text = todoItem.name
         datePicker.date = todoItem.date
         noteView.text = todoItem.notes
         reminderSwitch.isOn = todoItem.reminderSet
         
         if reminderSwitch.isOn {
             dateLabel.textColor = .black
         }
         else {
             dateLabel.textColor = .gray
         }
        
        dateLabel.text = dateFormatter.string(from: todoItem.date)
        enableDisableSaveButton(text: nameField.text!)
     }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        todoItem = nameField.text
//        todoItem = ToDoItem(name: nameField.text!, date: todoDatePicker.date, notes: todoNotes.text)
        todoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: todoItem.completed)
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
        self.view.endEditing(true)
        if reminderSwitch.isOn {
            dateLabel.textColor = .black
        }
        else {
            dateLabel.textColor = .gray
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveButton(text: sender.text!)
        
    }
    
    func enableDisableSaveButton(text: String) {
        if text.count > 0 {
            print("HIT IF Save Button. Count is \(text.count).")
            saveBarButton.isEnabled = true
        } else {
            print("HIT ELSE Save Button. Count is \(text.count).")
            saveBarButton.isEnabled = false
        }
    }
    

    
    
}


extension ToDoDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height : 0
        case notesTextViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
        }
    }
}

extension ToDoDetailTableViewController: UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField)  -> Bool {
        noteView.becomeFirstResponder()
        return true
    }
}
