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
    
    func confirmLeave(parameter:Dictionary<String,Any>,completionBlock:((Bool,String?, String?) -> Void)!){
        
        let url = URL(string: BASE_URL+CONFIRM_LEAVE)
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //        let jsonData = try
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do{
                    let jsonDecoder = JSONDecoder()
                    if data != nil{
                        let responseModel = try jsonDecoder.decode(LeaveChatModal.self, from: data!)
                        completionBlock(true,nil,"success")
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
//    func uploadRecipt(image: Data!,completionBlock:((Bool,String?, LeaveChatModal?) -> Void)!)  {
//        
//        let url = URL(string: "http://192.168.10.246:8080/user/file/text")
//        var request = URLRequest(url: url!)
//        request.setValue("multipart/form-data; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        let params = ["key" : data]
//        //        let jsonData = try
//        do{
//            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
//            
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                do{
//                    let jsonDecoder = JSONDecoder()
//                    let responseModel = try jsonDecoder.decode(LeaveChatModal.self, from: data!)
//                    completionBlock(true,nil,responseModel)
//                }        catch let error as Error {
//                    print("\(error)")
//                }
//            }
//            
//            task.resume()
//        }catch {
//            print(error)
//        }
//    }
}


extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
