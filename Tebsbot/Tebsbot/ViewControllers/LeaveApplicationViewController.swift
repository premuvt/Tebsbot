//
//  LeaveApplicationViewController.swift
//  Tebsbot
//
//  Created by uvionics on 25/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController

class LeaveApplicationViewController: UIViewController {
    @IBOutlet weak var leaveTableView: UITableView!
    var cell : LeaveApplicationCell? = nil
    var selectedImage: UIImage? = nil
    var imageSelected: Bool = false
    var startDate: Date? = nil
    var endDate: Date? = nil
    var fileName:String? = ""
    var imagePicker = UIImagePickerController()
    var alert = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelClicked))
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CalendarDateRangePickerViewController.didTapDone))
        
    }
    @objc func cancelClicked(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    @objc func buttonAddClicked(sender:UIButton){
        let cameraAction = UIAlertAction(title: "Camera", style: .default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
//        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
//        imagePicker.delegate = self
//        self.present(imagePicker, animated: true, completion: nil)
        
//        imageSelected = true
//        self.leaveTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        debugPrint("add button tapped")
        
    }
    @objc func buttonDeleteTapped(sender:UIButton){
        imageSelected = false
        self.leaveTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        debugPrint("delete tapped")
        
    }
    @objc func buttonCalendarClicked(sender:UIButton){
        debugPrint("calender tapped")
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        dateRangePickerViewController.clearsSelectionOnViewWillAppear = true
        self.navigationController?.present(navigationController, animated: false, completion: nil)
        
    }
    
}

extension LeaveApplicationViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
       imageSelected = true
        self.leaveTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
//        self.buttonupload.isUserInteractionEnabled = true
//        self.buttonupload.isEnabled = true
        let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        
        self.fileName = imageURL.absoluteString
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}
extension LeaveApplicationViewController:UINavigationControllerDelegate{
    
}

// MARK:- TableView Delegate and Datasource

extension LeaveApplicationViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowNumber = indexPath.row
        switch rowNumber {
        case 0:
            return 65.0
        case 1:
            if imageSelected{
                return 150.0
            }else{
                return 105.0
            }
        case 2:
            return 69.0
        case 3:
            return 65.0
        case 4:
            return 153.0
        case 5:
            return 150.0
        default:
            return 0
        }
    }
}

extension LeaveApplicationViewController: CalendarDateRangePickerViewControllerDelegate{
    
    func didTapCancel() {
        debugPrint("Cancel Clicked")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        debugPrint("Start Date :",startDate!)
        self.startDate =  startDate
        debugPrint("End Date :",endDate!)
        self.endDate =  endDate
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}


extension LeaveApplicationViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        switch rowNumber {
        case 0:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! LeaveApplicationCell)
        case 1:
            if imageSelected {
                cell = (tableView.dequeueReusableCell(withIdentifier: "Cell6", for: indexPath) as! LeaveApplicationCell)
                cell?.recieptImageView.image = self.selectedImage
                cell?.buttonDelete.addTarget(self, action: #selector(buttonDeleteTapped(sender:)), for: .touchUpInside)
            }else{
                cell = (tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! LeaveApplicationCell)
                cell?.addButton.addTarget(self, action: #selector(buttonAddClicked(sender:)), for: .touchUpInside)
            }
            
        case 2:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! LeaveApplicationCell)
        case 3:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! LeaveApplicationCell)
            cell?.buttonCalender.addTarget(self, action: #selector(buttonCalendarClicked(sender:)), for: .touchUpInside)
            cell?.dateTextField.addTarget(self, action: #selector(buttonCalendarClicked(sender:)), for: .touchUpInside)
        case 4:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell5", for: indexPath) as! LeaveApplicationCell)
        default:
            cell = (UITableViewCell() as! LeaveApplicationCell)
        }
        return cell!
    }
    
    
}


// MARK:- TableViewCell Class

class LeaveApplicationCell:UITableViewCell{
    
    // cell 1 progress view
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressOuterView: UIView!
    
    // cell 2
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var labelScan: UILabel!
    
    // cell 3
    
    @IBOutlet weak var labelSubmitDetails: UILabel!
    @IBOutlet weak var labelPickdates: UILabel!
    
    // cell 4
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var buttonCalender: UIButton!
    
    // cell 5
    
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var lbelReason: UILabel!
    
    // cell 6
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var recieptImageView: UIImageView!
    @IBOutlet weak var labelAttachment: UILabel!
    
    override func awakeFromNib() {
        // cell 1 progress view
        if progressView != nil && progressOuterView != nil{
            progressView.layer.cornerRadius = 3.0
            progressView.layer.masksToBounds = true
            progressOuterView.layer.cornerRadius = 3.0
            progressOuterView.layer.masksToBounds = true
        }
        
        
    }
}
