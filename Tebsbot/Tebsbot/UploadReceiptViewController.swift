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
    
    let url = "http://192.168.10.246:8080/user/file/text"
    var data: Data? = nil
    
    // MARK: - outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fileNameLabel: UILabel!
    
    @IBOutlet weak var buttonbrowse: UIButton!
    
    @IBOutlet weak var buttonupload: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    var selectedImage:UIImage!
    var fileName:String!
    var responceDateString:String!
    var responceClaimString:String!
    var responceFareString:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "arrow"), for: UIControl.State.normal)
        button.addTarget(self, action:#selector(ApplyLeaveViewController.backAction), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
//        self.buttonupload.isUserInteractionEnabled = false
//        self.buttonupload.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func setUpUI(){
        buttonbrowse.layer.cornerRadius = buttonbrowse.frame.height / 2
        buttonbrowse.layer.masksToBounds = true
        buttonupload.layer.cornerRadius = buttonupload.frame.height / 2
        buttonupload.layer.masksToBounds = true
    }

    @IBAction func onBrowse(_ sender: UIButton) {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func buttonUploadPressed(_ sender: Any) {
        print("upload initiated")
        if selectedImage != nil {
            if let data = selectedImage.jpegData(compressionQuality: 0.75) {
                //            let parameters: Parameters = [
                //                "access_token" : "YourToken"
                //            ]
                // You can change your image name here, i use NSURL image and convert into string
                
                // Start Alamofire
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(self.selectedImage.jpegData(compressionQuality: 0.75)!, withName: "file", fileName: "file", mimeType: "image/jpeg")
                    //                for (key, value) in parameters {
                    //                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    //                }
                }, to:"https://tebsbot.uvionicstech.com/teBSbot/user/file/text")
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
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                let responseJSON = response.result.value as! [String:AnyObject]
                                if  (responseJSON["data"]?["data"]) != nil{
                                    let data = (responseJSON["data"]?["data"] as! [String : AnyObject])
                                    self.responceDateString = data["date"] as? String
                                    self.responceClaimString = data["claim_type"]! as? String
                                    self.responceFareString = data["fare_amount"]! as? String
                                    
                                    self.pushToConfirmView()
                                }
                                else{
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
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ClaimConfirmViewController") as! ClaimConfirmViewController
        controller.responceFareString = self.responceFareString
        controller.responceClaimString = self.responceClaimString
        controller.responceDateString = self.responceDateString
        controller.selectedImage = self.selectedImage
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
