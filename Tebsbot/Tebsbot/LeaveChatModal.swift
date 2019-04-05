//
//  LeaveChatModal.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
struct LeaveChatModal : Codable {
    let data : Data?
    let message : String?
    let flag : Bool?
    var currentDate = Date()
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case message = "message"
        case flag = "flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        flag = try values.decodeIfPresent(Bool.self, forKey: .flag)
        currentDate = Date()
    }
    
}
struct Data : Codable {
    let flag : Int?
    let question : String?
    let sentence : String?
    let leave : String?
    let type : String?
    let date : String?
    
    enum CodingKeys: String, CodingKey {
        
        case flag = "Flag"
        case question = "Question"
        case sentence = "Sentence"
        case leave = "Leave"
        case type = "Type"
        case date = "Date"
    }
    
    
}
