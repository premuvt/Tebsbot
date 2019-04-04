//
//  UploadReceiptViewController.swift
//  Tebsbot
//
//  Created by uvionics on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import UIKit

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
        self.sendFile(urlPath: url, fileName: "\(self.fileNameLabel).png", data: data!) { (response, data, error) in
            if (response != nil){
                
            }else{
                
            }
        }
    }
    
}

extension UploadReceiptViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        self.fileNameLabel.text = "File Selected"
        data = selectedImage.pngData()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func sendFile(
        urlPath:String,
        fileName:String,
        data:Data,
        completionHandler: @escaping (URLResponse!, NSData!, NSError!) -> Void){
        
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        
        request1.httpMethod = "POST"
        
        let boundary = generateBoundary()
        let fullData = photoDataToFormData(data,boundary:boundary,fileName:fileName)
        
        request1.setValue("multipart/form-data; boundary=" + boundary,
                          forHTTPHeaderField: "Content-Type")
        
        // REQUIRED!
        request1.setValue(String(fullData.length), forHTTPHeaderField: "Content-Length")
        
        request1.HTTPBody = fullData
        request1.httpShouldHandleCookies = false
        
        let queue:OperationQueue = OperationQueue()
        do{
        NSURLConnection.sendAsynchronousRequest(
            request1 as URLRequest,
            queue: queue,
            completionHandler:completionHandler)
        }catch{
            debugPrint(error)
        }
    }
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
    func photoDataToFormData(data:Data,boundary:String,fileName:String) -> NSData {
        var fullData = NSMutableData()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: .utf8,
            allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
            using: .utf8,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: .utf8,
            allowLossyConversion: false)!)
        
        // 4
        fullData.append(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(using: .utf8,
            allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(using: .utf8,
            allowLossyConversion: false)!)
        
        return fullData
    }
}
