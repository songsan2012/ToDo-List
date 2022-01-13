//
//  ToDoDetailTableViewController.swift
//  ToDo List
//
//  Created by song on 1/12/22.
//  Copyright © 2022 song. All rights reserved.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var todoDatePicker: UIDatePicker!
    
    @IBOutlet weak var todoNotes: UITextView!
    
    var todoItem: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if todoItem == nil {
            todoItem = ""
        }
        
        nameField.text = todoItem
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        todoItem = nameField.text
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
    
    

}
