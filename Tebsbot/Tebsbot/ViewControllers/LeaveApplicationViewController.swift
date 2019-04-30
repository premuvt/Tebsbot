//
//  LeaveApplicationViewController.swift
//  Tebsbot
//
//  Created by uvionics on 25/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit
import CalendarDateRangePickerViewController
import Alamofire

class LeaveApplicationViewController: UIViewController {
    @IBOutlet weak var leaveTableView: UITableView!
    var cell : LeaveApplicationCell? = nil
    var selectedImage: UIImage? = nil
    var imageSelected: Bool = false
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    var imagePicker = UIImagePickerController()
    var alert : UIAlertController?
    var defaultTextFieldText = DEFAULT_TEXT
    var attributedText:NSAttributedString?
    var alertWarning : UIAlertController?
    
    var takenLeave:Int? = 10
    var totalLeave:Int? = 12
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    var isFromBot:Bool = false
    
    
    
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var inputAccessoryHight: NSLayoutConstraint!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBOutlet var submitView: UIView!
    @IBOutlet var confirmEditView: UIView!
    
    // Upload local variable
    var leaveType: String? = ""
    var reason :String? = ""
    var startDateString : String? = ""
    var endDateString : String? = ""
    var fileName:String? = ""
    var username:String? = UserDefaults.standard.object(forKey: "user") as! String
    var appliedDateTime:TimeZone?
    var isProgressInit:Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromBot {
            self.footerView.addSubview(self.confirmEditView)
            self.confirmEditView.bindFrameToSuperviewBounds()
//            if startDate == nil{
//                self.buttonConfirm.isEnabled = false
//                self.buttonConfirm.backgroundColor = CONFIRM_DISABLED_BG_COLOR
//            }else{
//                self.buttonConfirm.isEnabled = true
//                self.buttonConfirm.backgroundColor = CONFIRM_ENABLED_BG_COLOR
//            }
        }
        else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancelClicked))
            self.footerView.addSubview(self.submitView)
            self.submitView.bindFrameToSuperviewBounds()
        }
        leaveTableView.delegate = self
        setButtons()
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpKeyBoardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyBoardNotification()
    }
    func setButtons(){
        
        self.buttonSubmit.setCornerRaius()
        self.buttonEdit.setCornerRaius()
        self.buttonConfirm.setCornerRaius()
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
    func removeKeyBoardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
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
        self.buttonSubmit.isEnabled = false
        self.dismissKeyboard()
        resignFirstResponder()
        validation()
    }
    
    
    
    @IBAction func buttonEditClicked(_ sender: Any) {
        self.isFromBot = !self.isFromBot
        self.buttonEdit.backgroundColor = self.isFromBot ? EDIT_BACKGROUND_COLOR:EDIT_BACKGROUND_COLOR_SELECTED
        self.leaveTableView.reloadData()
        self.buttonConfirm.isEnabled = true
        self.buttonConfirm.backgroundColor = CONFIRM_ENABLED_BG_COLOR
    }
    @IBAction func buttonConfirmClicked(_ sender: Any) {
        if startDate == nil{
           validation()
        }
        
        self.setUploadDate()
        self.buttonConfirm.isEnabled = false
        self.buttonSubmit.sendActions(for: .touchUpInside)
//        self.buttonConfirm.isEnabled = false
    }
    
    
    // MARK:- cell Button Actions
    
    @objc func cancelClicked(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonAddClicked(sender:UIButton){
        
        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
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
    
    
    @IBAction func onDateButton(_ sender: UIButton) {
        self.calenderOpened()
    }
    @objc func buttonCalendarClicked(sender:UIButton){
        debugPrint("calender tapped")
        self.calenderOpened()
    }
    @objc func calenderOpened(){
        let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
        dateRangePickerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: dateRangePickerViewController)
        if startDate != nil{
            if (startDate?.compare(endDate!))!.rawValue == 0{
                dateRangePickerViewController.selectedStartDate = startDate
            }else{
                dateRangePickerViewController.selectedStartDate = startDate
                dateRangePickerViewController.selectedEndDate = endDate
            }
        }
  
        
        
        //        dateRangePickerViewController.clearsSelectionOnViewWillAppear = true
        self.navigationController?.present(navigationController, animated: false, completion: nil)
        
    }
}



// MARK:- UIImagePickerControllerDelegate

extension LeaveApplicationViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
       imageSelected = true
        self.leaveTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        if imagePicker.sourceType != .camera{
        let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        
        self.fileName = imageURL.absoluteString
        }else{
            self.fileName = "TebsBotImage"
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


extension LeaveApplicationViewController{
    func validation(){
        if self.startDateString == "" || self.startDateString == nil {
            noDateMessage()
            enableButtons()
        }
        else if reason! == "" && leaveType?.lowercased() == "medical" {
             noReasonMessage()
            enableButtons()
        }
        else{
          uploadApplyLeaveData()
            
        }
    }
    
    func enableButtons(){
        self.buttonSubmit.isEnabled = true
        self.buttonConfirm.isEnabled = true
          self.buttonConfirm.backgroundColor = CONFIRM_ENABLED_BG_COLOR
        self.buttonEdit.isEnabled = isFromBot
          self.buttonEdit.backgroundColor = EDIT_BACKGROUND_COLOR_SELECTED
    }
    func scrollToBottomTable(){
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let indexPath = IndexPath(
                row: 4,
                section: 0)
            self.leaveTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func noReasonMessage(){
        setAlert(message: NO_REASON)
//        enableButtons()
    }
    func noDateMessage(){
        setAlert(message: NO_DATERANGESELECTED)
        
    }
    
    func setAlert(message:String){
        resignFirstResponder()
        self.dismissKeyboard()
        alertWarning = UIAlertController(title: "TebsBot", message: message, preferredStyle: .alert)//UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
        let okAction = UIAlertAction(title: "OK", style: .default)
        {
            UIAlertAction in
           self.alertWarning!.dismiss(animated: false, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        {
            UIAlertAction in
            self.alertWarning!.dismiss(animated: false, completion: nil)
        }
        alertWarning?.addAction(okAction)
        self.present(alertWarning!, animated: true, completion: nil)
    }
    
    func uploadApplyLeaveData(){
        
        //        print("upload initiated")
        //        self.activityIndicator("Uploading..")
        let parameters : [String : String]?
        var name : String = ""
        if self.fileName == ""{
            parameters =  [
                "leaveType": self.leaveType!,
                "username": username!,
                "reason": reason!,
                "startDate": startDateString!,
                "endDate": endDateString!,
                "appliedDateTime": "\(Date().ticks)"
            ]
        }else{
            name = self.fileName! + ".JPG"
            parameters =  [
                "file": name,
                "leaveType": self.leaveType!,
                "username": username!,
                "reason": reason!,
                "startDate": startDateString!,
                "endDate": endDateString!,
                "appliedDateTime": "\(Date().ticks)"
            ]
        }

 
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            if self.selectedImage != nil{
                multipartFormData.append(self.selectedImage!.jpegData(compressionQuality: 1)!, withName:"file", fileName: name, mimeType: "image/jpeg")
                
            }
            for (key, value) in parameters! {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:BASE_URL+LEAVE_UPLOAD)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    debugPrint("progress",progress)
                    //Print progress
                })
                
                upload.responseJSON { response in
                    //print response.result
                    DispatchQueue.main.async {
                        self.buttonSubmit.isEnabled = true
                        self.buttonConfirm.isEnabled = true
                    }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LeaveConfirmationViewController")
                    self.navigationController?.present(controller, animated: true)
                }
                
            case .failure(let encodingError): break
                //print encodingError.description
            }
        }

    }

    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    
    func stopActivity() {
        activityIndicator.stopAnimating()
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
    }
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
        setUploadDate()
        
        self.navigationController?.dismiss(animated: false, completion: {
            self.leaveTableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        })
    }

    // MARK:- set Upload date
    
    func setUploadDate(){
        self.startDateString = self.startDate?.setTimeFormatwithYear()
        self.endDateString = self.endDate?.setTimeFormatwithYear()
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
            if leaveType?.lowercased() == "medical" {
                if imageSelected{
                    return 150.0
                }else{
                    return 105.0
                }
            }
            else {
                return 0
            }
        case 2:
            return 69.0
        case 3:
            return 70.0
        case 4:
            return 153.0
        case 5:
            return 150.0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            break
        case 3:
            self.calenderOpened()
        default:
            break
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
            cell?.progressValueLabel.text = "\(takenLeave!) / \(totalLeave!)"
            cell?.leaveStatusProgress.progress = Float(takenLeave!) / Float(totalLeave!)
            if !self.isProgressInit {
                self.isProgressInit = true
                cell?.leaveStatusProgress.transform = (cell?.leaveStatusProgress.transform.scaledBy(x: 1, y: 2))!
            }
            
        case 1:
            if imageSelected {
                cell = (tableView.dequeueReusableCell(withIdentifier: "Cell6", for: indexPath) as! LeaveApplicationCell)
                cell?.recieptImageView.image = self.selectedImage
                cell?.buttonDelete.addTarget(self, action: #selector(buttonDeleteTapped(sender:)), for: .touchUpInside)
                cell?.buttonDelete.isEnabled = !isFromBot
            }else{
                cell = (tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! LeaveApplicationCell)
                cell?.addButton.addTarget(self, action: #selector(buttonAddClicked(sender:)), for: .touchUpInside)
                cell?.addButton.isEnabled = !isFromBot
            }
            
        case 2:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! LeaveApplicationCell)
        case 3:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! LeaveApplicationCell)
            cell?.buttonCalender.addTarget(self, action: #selector(buttonCalendarClicked(sender:)), for: .touchUpInside)
//            cell?.dateTextField.addTarget(self, action: #selector(buttonCalendarClicked(sender:)), for: .touchUpInside)
            cell?.dateTextField.delegate =  self
            cell?.buttonCalender.isEnabled = !isFromBot
            cell?.dateTextField.isEnabled = false
            cell?.dateLabelButton.isEnabled = !isFromBot
            
            if startDate != nil {
                if endDate == startDate{
                    defaultTextFieldText = (startDate?.setTimeFormat())!
                }else{
                    
                    defaultTextFieldText = "\((self.startDate?.setTimeFormat())!)    to   \((self.endDate?.setTimeFormat())!)"
                }
            }else{
                defaultTextFieldText = DEFAULT_TEXT
            }
            
            cell?.dateTextField.attributedText = setAttributedText()
        case 4:
            cell = (tableView.dequeueReusableCell(withIdentifier: "Cell5", for: indexPath) as! LeaveApplicationCell)
            cell?.reasonTextView.text = reason
            cell?.reasonTextView.delegate = self
            cell?.reasonTextView.isUserInteractionEnabled = !isFromBot
            
        default:
            cell = (UITableViewCell() as! LeaveApplicationCell)
        }
        return cell!
    }
    
    
    
    func setAttributedText() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: defaultTextFieldText)
        let textLength = defaultTextFieldText.count
        var color = UIColor.black
        if defaultTextFieldText == DEFAULT_TEXT {
            color = UIColor.gray
        }
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .backgroundColor: UIColor.white]
        let secondAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(red: 85.0 / 255.0, green: 99.0 / 255.0, blue: 151.0 / 255.0, alpha: 1),
            .backgroundColor: UIColor.white]
        if textLength > 12{
            attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 12))
            attributedString.addAttributes(secondAttributes, range: NSRange(location: 12, length: 6))
            attributedString.addAttributes(firstAttributes, range: NSRange(location: textLength - 11, length: 11))
        }else{
            attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: textLength))
        }
        attributedText = attributedString
        return attributedText!
    }
}
extension LeaveApplicationViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.calenderOpened()
    }
}


// MARK:- TableViewCell Class

class LeaveApplicationCell:UITableViewCell{
    
    // cell 1 progress view
    
    
    @IBOutlet weak var leaveStatusProgress: UIProgressView!
    @IBOutlet weak var progressValueLabel: UILabel!
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
    
    @IBOutlet weak var dateLabelButton: UIButton!
    
    override func awakeFromNib() {
        // cell 1 progress view
        if leaveStatusProgress != nil{
            leaveStatusProgress.layer.cornerRadius = 3
            leaveStatusProgress.layer.masksToBounds = true
        }
    }
}

extension LeaveApplicationViewController:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        debugPrint(canBecomeFirstResponder)
        textView.becomeFirstResponder()
        self.scrollToBottomTable()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil && textView.text.isEmpty{
            self.reason = ""
        }else{
            self.reason = textView.text
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.isEmpty || textView.text == ""{
            reason = ""
            return true
        }
        else{
            reason = textView.text
            return true
        }
    }
    

}
