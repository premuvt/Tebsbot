//
//  UploadReceiptViewController.swift
//  Tebsbot
//
//  Created by uvionics on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit
import Alamofire

class UploadReceiptViewController: UIViewController {
    
    //MARK:- VARIABLE
    
    let url = BASE_URL+FILE_UPLOAD
    var data: Data? = nil
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
//    @IBOutlet weak var departmentTextField: UITextField!
    // MARK: - outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet weak var buttonbrowse: UIButton!
    
    @IBOutlet weak var buttonupload: UIButton!
    @IBOutlet weak var buttonDepartment: UIButton!
    @IBOutlet weak var departmentLabel: UILabel!
    
    
    var imagePicker = UIImagePickerController()
    var selectedImage:UIImage!
    var fileName:String!
    var responceDateString:String!
    var responceClaimString:String!
    var responceFareString:String!
    var departmentString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView

        
        let rightButton = UIButton.init(type: .custom)
        rightButton.setImage(UIImage.init(named: "logout"), for: UIControl.State.normal)
        rightButton.addTarget(self, action:#selector(logout(sender:)), for:.touchUpInside)
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButtonRight = UIBarButtonItem.init(customView: rightButton)
        self.navigationItem.rightBarButtonItem = barButtonRight
        
        let userName = UserDefaults.standard.object(forKey: "user") as! String
        self.nameLabel.text = "Hi "+userName.capitalized
        
        if departmentString == ""{
            self.departmentLabel.text = "Select Cost Centre"
        }else{
            self.departmentLabel.text = departmentString
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.selectedImage = nil
        self.fileName = ""
        self.fileNameLabel.text = "No file selected.."
        self.buttonupload.isUserInteractionEnabled = false
        self.buttonupload.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(){

        buttonDepartment.imageEdgeInsets
        .left = self.buttonDepartment.frame.width - 45
        self.buttonbrowse.setCornerRaius()
        self.buttonupload.setCornerRaius()
    }

    @IBAction func buttonDepartmentTapped(_ sender: UIButton) {
        self.buttonDepartment.isEnabled = false
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        /DepartmentSelectionViewController
        
        let departmentSlectionViewController = storyboard.instantiateViewController(withIdentifier: "DepartmentSelectionViewController") as! DepartmentSelectionViewController
        departmentSlectionViewController.departmentDelegate = self

        self.navigationController?.present(departmentSlectionViewController, animated: true)

    }
    
    @IBAction func onBrowse(_ sender: UIButton) {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func buttonUploadPressed(_ sender: Any) {
        print("upload initiated")
        self.activityIndicator("Uploading..")
        if selectedImage != nil {
            if let data = selectedImage.jpegData(compressionQuality:1.0) {
                // Start Alamofire
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(self.selectedImage.jpegData(compressionQuality: 1)!, withName: "file", fileName: "file.JPG", mimeType: "image/jpeg")
                }, to:BASE_URL+FILE_UPLOAD)
                { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        upload.responseJSON { response in
                            //self.delegate?.showSuccessAlert()
                            print(response.request)  // original URL request
                            print(response.response) // URL response
                            print(response.data)     // server data
                            print(response.result)   // result of response serialization
                            //                        self.showSuccesAlert()
                            //self.removeImage("frame", fileExtension: "txt")
                            if  response.result.description == "FAILURE"{
                                DispatchQueue.main.async {
                                    self.stopActivity()
                                }
                                print("faild processing")
                                let alert = UIAlertController(title: "Information", message: "Processing failed", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action) in
                                    alert.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                let responseJSON = response.result.value as! [String:AnyObject]
                                if  (responseJSON["data"]?["data"]) != nil{
                                    let data = (responseJSON["data"]?["data"] as! [String : AnyObject])
                                    self.responceDateString = data["date"] as? String
                                    self.responceClaimString = data["claim_type"]! as? String
                                    self.responceFareString = data["fare_amount"]! as? String
                                    DispatchQueue.main.async {
                                        self.stopActivity()
                                    }
                                    self.pushToConfirmView()
                                }
                                else{
                                    DispatchQueue.main.async {
                                        self.stopActivity()
                                    }
                                    print("faild processing")
                                    let alert = UIAlertController(title: "Information", message: "Processing faild", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action) in
                                        alert.dismiss(animated: true, completion: nil)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                             }
                        }
                    case .failure(let encodingError):
                        //self.delegate?.showFailAlert()
                        print(encodingError)
                    }
                }
            }
        }
        else{
            print("no image selecte")
            let alert = UIAlertController(title: "Information", message: "Please select an image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UploadReceiptViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        self.fileNameLabel.text = "File Selected"
        self.buttonupload.isUserInteractionEnabled = true
        self.buttonupload.isEnabled = true
        
        let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        self.fileName = imageURL.absoluteString
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func pushToConfirmView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ClaimConfirmViewController") as! ClaimConfirmViewController
            controller.responceFareString = self.responceFareString
            controller.responceClaimString = self.responceClaimString
            controller.responceDateString = self.responceDateString
            controller.selectedImage = self.selectedImage
            controller.departmentString = self.departmentString
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        debugPrint("HI")
    }
    
    //MARK:- activity indicator
    
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

extension UploadReceiptViewController:DepartmentSelectionDelegate{
    func departmentSelected(selectedDepartment: String) {
        self.buttonDepartment.isEnabled = true
        self.dismiss(animated: false, completion:nil)
        departmentString = selectedDepartment
//        self.buttonDepartment.titleLabel!.text = departmentString
        self.departmentLabel.text = departmentString
        
    }
    func didCanceldepartmentSelected () {
        self.buttonDepartment.isEnabled = true
    }
    
}
extension UploadReceiptViewController:UIPopoverPresentationControllerDelegate{
    
}
extension UploadReceiptViewController{
    @objc func logout(sender:UIButton){
        let alert = UIAlertController.init(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.alertWithOkCancelButton(view: self, okAction: .logout)

    }
}
