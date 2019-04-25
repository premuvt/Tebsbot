//
//  LeaveApplicationViewController.swift
//  Tebsbot
//
//  Created by uvionics on 25/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

class LeaveApplicationViewController: UIViewController {
    @IBOutlet weak var leaveTableView: UITableView!
    var cell : LeaveApplicationCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension LeaveApplicationViewController:UITableViewDelegate{
    
}


extension LeaveApplicationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! LeaveApplicationCell
        
        
        return cell!
    }
    
    
}

class LeaveApplicationCell:UITableViewCell{
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressOuterView: UIView!
    override func awakeFromNib() {
        progressView.layer.cornerRadius = 2.0
        progressView.layer.masksToBounds = true
        progressOuterView.layer.cornerRadius = 2.0
        progressOuterView.layer.masksToBounds = true
    }
}
