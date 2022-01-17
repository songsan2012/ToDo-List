//
//  ListTableViewCell.swift
//  ToDo List
//
//  Created by song on 1/16/22.
//  Copyright © 2022 song. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    
    func checkBoxToggle(sender: ListTableViewCell)
    
}

class ListTableViewCell: UITableViewCell {

    weak var delegate: ListTableViewCellDelegate?
    
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    var toDoItem: ToDoItem! {
        didSet {
            nameLabel.text = toDoItem.name
            checkboxButton.isSelected = toDoItem.completed
        }
    }
    
    
    
    @IBAction func checkToggle(_ sender: UIButton) {
        
        delegate?.checkBoxToggle(sender: self)
    }
    
}



