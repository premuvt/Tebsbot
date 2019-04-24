//
//  LeaveHomeSummaryTableViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 18/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class LeaveHomeSummaryNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var logoimage = UIImage(named: "logo")
        var bellimage = UIImage(named: "logo")
        var menuimage = UIImage(named: "logo")
        logoimage = logoimage?.withRenderingMode(.alwaysOriginal)
        bellimage = bellimage?.withRenderingMode(.alwaysOriginal)
        menuimage = menuimage?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoimage, style:.plain, target: nil, action: nil)
        let menu  = UIBarButtonItem(image: menuimage, style:.plain, target: nil, action: nil)
        let bell  = UIBarButtonItem(image: bellimage, style:.plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItems = [bell,menu]
    }
}
class LeaveHomeSummaryTableViewController: UITableViewController {
    
    
    //variables
    var myLeaves:MyLeaveListModal?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getLeavelist()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            if let leaveCount = myLeaves?.data?.count {
                return leaveCount
            }
            return 0
        default:
            return 2
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "LeaveSummaryHeaderCell", for: indexPath)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "MyCalenderCell", for: indexPath)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "LeaveSummaryHeaderCell", for: indexPath)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
        } else{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "LeaveCell", for: indexPath) as! LeaveCell
            if let data:Data = self.myLeaves?.data![indexPath.row]{
                (cell as! LeaveCell).setCellData(data: data)
            }
            
            cell.separatorInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 20 )
            
        }
        
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            if indexPath.section == 0 {
                return 125
            }
            else{
                return 120
            }
        default:
            if indexPath.section == 0 {
               return 25
            }
            else{
                return 120
            }
            
        }
    }
    
    func getLeavelist() {
        WebService.shared.getLeaveList { (status, errorMessage, resultLeaveList) in
            if status {
                self.myLeaves = resultLeaveList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            else{
                
            }
        }
    }
}
