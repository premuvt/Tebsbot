//
//  DepartmentSelectionTableViewController.swift
//  Tebsbot
//
//  Created by uvionics on 29/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

protocol DepartmentSelectionDelegate {
    func departmentSelected(selectedDepartment:String)
    func didCanceldepartmentSelected()
}
class DepartmentSelectionTableViewController: UITableViewController {
    var departments : [String] = ["Sales","AMS","delivery team","","Close"]
    var departmentDelegate : DepartmentSelectionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return departments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCell", for: indexPath) as! DepartmentTableViewCell
        cell.departmentNameLabel.text = departments[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == (departments.count - 1) {
            self.departmentDelegate?.didCanceldepartmentSelected()
            self.dismiss(animated: true, completion: nil)
        }
        else if departments[indexPath.row].count > 0 {
            self.departmentDelegate?.departmentSelected(selectedDepartment: departments[indexPath.row])
        }
        
        
    }


}

class DepartmentTableViewCell:UITableViewCell{
    @IBOutlet weak var departmentNameLabel: UILabel!
    override func awakeFromNib() {
        
    }
}
