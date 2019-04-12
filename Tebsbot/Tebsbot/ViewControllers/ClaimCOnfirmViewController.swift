//
//  ClaimCOnfirmViewController.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
import UIKit
class ClaimConfirmViewController: UIViewController {
    
    var responceDateString:String!
    var responceClaimString:String!
    var responceFareString:String!
    var selectedImage:UIImage!
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var isZooming = false
    var originalImageCenter:CGPoint?
    
    
    @IBOutlet var imagePanGesture: UIPanGestureRecognizer!
    @IBOutlet weak var scrollViewImage: UIScrollView!
    @IBOutlet var claimImagePanGesture: UIPinchGestureRecognizer!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reciptImageview: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLable: UILabel!
    var lastScale:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // pinch gesture
         self.claimImagePanGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        self.reciptImageview.addGestureRecognizer(self.claimImagePanGesture)
        self.claimImagePanGesture.delegate = self
        
        // pangesture
       imagePanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
    self.reciptImageview.addGestureRecognizer(imagePanGesture)
        imagePanGesture.delegate = self
        
        reciptImageview.isUserInteractionEnabled = true
        reciptImageview.image = selectedImage
        typeLabel.text = "Claim Type - \(responceClaimString ?? "no type")"
        dateLabel.text = "Date - \(responceDateString ?? "no date")"
        amountLable.text = "Claim Amount - \(responceFareString ?? "no amount")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.backgroundColor = UIColor.white
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    

    
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.activityIndicator("Confirming...")
        sender.isEnabled = false
        let dictionaryClaim: Dictionary<String,String> = ["date":responceDateString,"claim_type":responceClaimString,"fare_amount":responceFareString]
        WebService.shared.confirmClaim(parameter: dictionaryClaim) { (success, errorMessage, successMessage) in
            sender.isEnabled = true
            if success{
                DispatchQueue.main.sync {
                    self.stopActivity()
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let claimConfirmationPage = storyboard.instantiateViewController(withIdentifier: "ClaimConfirmationPageViewController") as! ClaimConfirmationPageViewController
                    self.navigationController?.pushViewController(claimConfirmationPage, animated: true)
                }
            }else{
                debugPrint("errorMessage")
            }
        }
        
        

    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
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
    
    
    func updateUI(){
        self.confirmButton.setCornerRaius()
        self.cancelButton.setCornerRaius()
    }
}


extension ClaimConfirmViewController:UIGestureRecognizerDelegate{
    
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: self.view)
            if let view = sender.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            sender.setTranslation(CGPoint.zero, in: self.reciptImageview.superview)
        }
    }
    
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        if sender.state == .began {
            let currentScale = self.reciptImageview.frame.size.width / self.reciptImageview.bounds.size.width
            let newScale = currentScale*sender.scale
            debugPrint("zoomlevel : ",newScale)
            if newScale < 1  && newScale > 7 {
                guard let center = self.originalImageCenter else {return}
                UIView.animate(withDuration: 0.3, animations: {
                    self.reciptImageview.transform = CGAffineTransform.identity
                    self.reciptImageview.center = center
                }, completion: { _ in
                    self.isZooming = false
                })
                
            }else if newScale > 1 && newScale < 7{
                self.isZooming = true
            }else{
                self.isZooming = false
            }
            
        } else if sender.state == .changed {
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let currentScale = self.reciptImageview.frame.size.width / self.reciptImageview.bounds.size.width
            var newScale = currentScale*sender.scale
            if newScale < 1 && newScale > 7{
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                
                guard let center = self.originalImageCenter else {return}
                UIView.animate(withDuration: 0.3, animations: {
                    view.transform =  CGAffineTransform.identity
                    self.reciptImageview.transform = CGAffineTransform.identity
                    self.reciptImageview.center = center
                    sender.scale = 1
                }, completion: { _ in
                    self.isZooming = false
                })
            }else if newScale > 1 && newScale < 7{
                view.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                self.reciptImageview.transform = CGAffineTransform.identity
                self.reciptImageview.center = center
            }, completion: { _ in
                self.isZooming = false
            })
        }
        
    }
    
    
}
