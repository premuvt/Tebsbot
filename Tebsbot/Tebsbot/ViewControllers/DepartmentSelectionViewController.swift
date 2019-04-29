//
//  DepartmentSelectionViewController.swift
//  Tebsbot
//
//  Created by uvionics on 29/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

class DepartmentSelectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var departments : [String] = ["Sales","AMS","delivery team"]
    var departmentDelegate : DepartmentSelectionDelegate?

    @IBOutlet weak var departmentTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCell", for: indexPath) as! DepartmentTableViewCell
        cell.departmentNameLabel.text = departments[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.departmentDelegate?.departmentSelected(selectedDepartment: departments[indexPath.row])
        
    }
}
