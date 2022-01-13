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
    
    var toDoArray = ["Learn Swift", "Publish App", "Change the world", "Take a vacation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }


}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("🤭 Number of rows in section: \(toDoArray.count)")
        return toDoArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        print("Cell at rowpath just called at \(cell)")
        return cell
    }
    
    
}

