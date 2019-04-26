//
//  LeaveTypePickerViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 25/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//


import Foundation
import UIKit
protocol LeaveTypePickerDelegate {
    func didSelectLeaveType(leaveatype:String,total:Int,taken:Int)
    func cancelledLeavePicker()
}

class LeaveTypePickerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableVIew: UITableView!
    var delegate:LeaveTypePickerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        
        self.tableVIew.layer.masksToBounds = true
        self.tableVIew.layer.cornerRadius = 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        
        if indexPath.row < 4 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Medical"
                cell.detailTextLabel?.text = "10/12"
            case 1:
                cell.textLabel?.text = "Annual"
                cell.detailTextLabel?.text = "10/12"
            case 2:
                cell.textLabel?.text = "Compensatory"
                cell.detailTextLabel?.text = "1/1"
            case 3:
                cell.textLabel?.text = "Child Care"
                cell.detailTextLabel?.text = "8/10"
            default:
                cell.textLabel?.text = "Medical"
                cell.detailTextLabel?.text = "10/12"
            }
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "close")!
            cell.textLabel?.text = "Close"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //to do
            print("Medical leave")
            self.delegate?.didSelectLeaveType(leaveatype: "Medical",total: 12,taken: 10)
        case 1:
            //to do
            print("Annual leave")
            self.delegate?.didSelectLeaveType(leaveatype: "Annual",total: 12,taken: 10)
        case 2:
            //to do
            print("Compensatory leave")
            self.delegate?.didSelectLeaveType(leaveatype: "Compensatory",total: 1,taken: 1)
        case 3:
            //to do
            print("Child Care leave")
            self.delegate?.didSelectLeaveType(leaveatype: "Child Care",total: 10,taken: 8)
        case 4:
            //to do
            print("Medical leave")
            self.delegate?.cancelledLeavePicker()
            
            
        default:
            print("default")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
