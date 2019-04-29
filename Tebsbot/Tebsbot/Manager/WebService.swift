//
//  WebService.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation

class WebService {
    static let shared = WebService()
    func applyLeaveChat(message: String,completionBlock:((Bool,String?, LeaveChatModal?) -> Void)!)  {
        
        let url = URL(string: BASE_URL+USER_MESSAGE)
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let params = ["sentence" : message]
//        let jsonData = try
        do{
        request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do{
                let jsonDecoder = JSONDecoder()
                if data != nil{
                let responseModel = try jsonDecoder.decode(LeaveChatModal.self, from: data!)
                completionBlock(true,nil,responseModel)
                }else{
                    completionBlock(false,"no data",nil)
                }
            }catch let error as Error {
                print("\(error)")
            }
        }
        
        task.resume()
        }catch {
            print(error)
        }
    }
    
    func confirmLeave(parameter:StringData?,completionBlock:((Bool,String?, String?) -> Void)!){
        
        let requestParams = ConfirmLeave.requestBody(stringParam: parameter!)
        let url = URL(string: BASE_URL+CONFIRM_LEAVE)
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //        let jsonData = try
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do{
                    let jsonDecoder = JSONDecoder()
                    
                    if data != nil{
                        let responseModel = try jsonDecoder.decode(LeaveConfirmModel.self, from: data!)
                        if responseModel.flag! {
                            completionBlock(true,nil,"success")
                        }
                        else{
                            completionBlock(false,nil,"fail")
                        }
                        
                    }else{
                        completionBlock(false,"no data",nil)
                    }
                }catch let error as Error {
                    print("\(error)")
                }
            }
            
            task.resume()
        }catch {
            print(error)
        }
    }
    func confirmClaim(parameter:Dictionary<String,String>,department:String,completionBlock:((Bool,String?, String?) -> Void)!){
        
        let requestParams = ConfirmClaim.requestBody(stringParam: parameter,departmentName: department)
        let url = URL(string: BASE_URL+CONFIRM_CLAIM)
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //        let jsonData = try
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: requestParams, options: .prettyPrinted)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do{
                    let jsonDecoder = JSONDecoder()
                    if data != nil{
                        let responseModel = try jsonDecoder.decode(LeaveConfirmModel.self, from: data!)
                        if responseModel.flag! {
                            completionBlock(true,nil,"success")
                        }
                        else{
                            completionBlock(false,nil,"fail")
                        }
                        
                    }else{
                        completionBlock(false,"no data",nil)
                    }
                }catch let error as Error {
                    print("\(error)")
                }
            }
            
            task.resume()
        }catch {
            print(error)
        }
    }

}




