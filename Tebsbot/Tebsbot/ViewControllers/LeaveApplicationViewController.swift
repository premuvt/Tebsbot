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
    var alert : UIAlertController?
    var defaultTextFieldText = DEFAULT_TEXT
    var attributedText:NSAttributedString?
    
    
    
    
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var inputAccessoryHight: NSLayoutConstraint!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelClicked))
        setButtons()
        setUpKeyBoardNotification()
        setUpView()
        
        
    }
    
    func setButtons(){
        self.buttonSubmit.layer.cornerRadius = self.buttonSubmit.frame.height / 2
        self.buttonSubmit.layer.masksToBounds = true
        self.buttonEdit.layer.cornerRadius = self.buttonEdit.frame.height / 2
        self.buttonEdit.layer.masksToBounds = true
        self.buttonConfirm.layer.cornerRadius = self.buttonConfirm.frame.height / 2
        self.buttonConfirm.layer.masksToBounds = true
    }
    func setUpView(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        leaveTableView.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func setUpKeyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK:- keyboard notification
    
    @objc func keyboardShow(notification:Notification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            inputAccessoryHight.constant += keyboardHeight - 5
            let duration = notification.userInfo as! Dictionary<String,Any>
            UIView.animate(withDuration: duration["UIKeyboardAnimationDurationUserInfoKey"]! as! TimeInterval, animations: {
                self.leaveTableView.scrollToRow(at: IndexPath(row: self.leaveTableView.numberOfRows(inSection: 0) - 1 , section: 0), at: .bottom, animated: true)
            })

        }
    }
    
    @objc func keyboardHide(notification:Notification){
        inputAccessoryHight.constant = 65

    }
    
    
    
    // MARK:-  Button Actions
    
    @IBAction func buttonSubmitClicked(_ sender: Any) {
        
        
    }
    @IBAction func buttonEditClicked(_ sender: Any) {
    }
    @IBAction func buttonConfirmClicked(_ sender: Any) {
    }
    
    
    // MARK:- cell Button Actions
    
    @objc func cancelClicked(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonAddClicked(sender:UIButton){
        
        alert = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
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
            self.dismissAlert()
            
        }
        
        // Add the actions
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        alert!.addAction(cameraAction)
        alert!.addAction(gallaryAction)
        alert!.addAction(cancelAction)
        self.present(alert!, animated: true, completion: nil)
        debugPrint("add button tapped")
        
    }
    @objc func buttonDeleteTapped(sender:UIButton){
        imageSelected = false
        selectedImage = nil
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



// MARK:- UIImagePickerControllerDelegate

extension LeaveApplicationViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
       imageSelected = true
        self.leaveTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
//        self.buttonupload.isUserInteractionEnabled = true
//        self.buttonupload.isEnabled = true
        if imagePicker.sourceType != .camera{
        let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        
        self.fileName = imageURL.absoluteString
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func openCamera(){
        self.alert!.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "TebsBot", message: "You don't have camera", preferredStyle: .alert)//UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            {
                UIAlertAction in
                self.dismiss(animated: false, completion: nil)
                
            }
            alertWarning.addAction(cancelAction)
            self.present(alertWarning, animated: true, completion: nil)
        }
    }
    func openGallery(){
        self.alert?.dismiss(animated: true, completion: nil)
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        self.alert!.dismiss(animated: false, completion: nil)
    }
    
}
extension LeaveApplicationViewController:UINavigationControllerDelegate{
    
}


// MARK:- CalendarDateRangePickerViewControllerDelegate

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
        self.navigationController?.dismiss(animated: false, completion: {
            self.leaveTableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        })
        
    }
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
            
            if startDate != nil {
                if endDate == startDate{
                    defaultTextFieldText = (startDate?.setTimeFormat())!
                }else{
                    
                    defaultTextFieldText = "\((self.startDate?.setTimeFormat())!)   to   \((self.endDate?.setTimeFormat())!)"
                }
            }else{
                defaultTextFieldText = DEFAULT_TEXT
            }
            
            cell?.dateTextField.attributedText = setAttributedText()
        case 4:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell5", for: indexPath) as! LeaveApplicationCell)
            cell?.reasonTextView.delegate = self
        default:
            cell = (UITableViewCell() as! LeaveApplicationCell)
        }
        return cell!
    }
    
    func setAttributedText() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: defaultTextFieldText)
        let textLength = defaultTextFieldText.count
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 208.0 / 255.0, green: 211.0 / 255.0, blue: 222.0 / 255.0, alpha: 1),
            .backgroundColor: UIColor.white]
        let secondAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 85.0 / 255.0, green: 99.0 / 255.0, blue: 151.0 / 255.0, alpha: 1),
            .backgroundColor: UIColor.white]
        
        attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 12))
        if textLength > 12{
            attributedString.addAttributes(secondAttributes, range: NSRange(location: 12, length: 6))
            attributedString.addAttributes(firstAttributes, range: NSRange(location: textLength - 11, length: 10))
        }
        attributedText = attributedString
        return attributedText!
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

extension LeaveApplicationViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        debugPrint(canBecomeFirstResponder)
        textView.becomeFirstResponder()
    }
    

}
