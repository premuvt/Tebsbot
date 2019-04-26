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
class LeaveHomeSummaryTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, LeaveTypePickerDelegate {
    
    
    //variables
    var myLeaves:MyLeaveListModal?
    var roundButton = UIButton()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyLeaveButton: UIButton!
    @IBOutlet weak var botButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getLeavelist()
        setupFooter()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavigationButtons()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    func setupFooter() {
        self.applyLeaveButton.layer.masksToBounds = true
        self.applyLeaveButton.layer.cornerRadius = self.applyLeaveButton.frame.height/2
        
        self.botButton.layer.masksToBounds = true
        self.botButton.layer.cornerRadius = self.botButton.frame.height/2
        
    }
    func setNavigationButtons() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        //left navigation item
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "nav-logo"), for: .normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
        //right navigation items
        let rigthbutton1 = UIButton(type: UIButton.ButtonType.custom)
        rigthbutton1.setImage(UIImage(named: "bell"), for: .normal)
        rigthbutton1.addTarget(self, action: #selector(onNotificationAction), for: .touchUpInside)
        let rightbarButton1 = UIBarButtonItem(customView: rigthbutton1)
        
        let rigthbutton2 = UIButton(type: UIButton.ButtonType.custom)
        rigthbutton2.setImage(UIImage(named: "menu"), for: .normal)
        rigthbutton2.addTarget(self, action: #selector(onMenuAction), for: .touchUpInside)
        let rightbarButton2 = UIBarButtonItem(customView: rigthbutton2)
        let fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        self.navigationItem.rightBarButtonItems = [rightbarButton2,fixedSpace,rightbarButton1]
    }
    @IBAction func applyAction(_ sender: Any) {
        print("Apply action")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller:LeaveTypePickerViewController = storyboard.instantiateViewController(withIdentifier: "LeaveTypePickerViewController") as! LeaveTypePickerViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func botAction(_ sender: Any) {
        print("Bot action")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ApplyLeaveViewController")
        self.navigationController?.pushViewController(controller, animated: true)

    }
    
    //leavetype picker delegate methords
    func didSelectLeaveType(leaveatype:String,total:Int,taken:Int){

        if leaveatype == "Medical"{
            self.dismiss(animated: false) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller:LeaveApplicationViewController = storyboard.instantiateViewController(withIdentifier: "LeaveApplicationViewController") as! LeaveApplicationViewController
                        let navigationController = UINavigationController(rootViewController: controller)
//                controller.delegate = self
                self.present(navigationController, animated: true, completion: nil)
            }
        }else{
            
        }
        print(leaveatype)
    }
    func cancelledLeavePicker(){
        print("cancelled picker")
    }
    @objc func onNotificationAction() {
        print("onNotificationAction")
    }
    @objc func onMenuAction() {
        print("onMenuAction")
    }
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

