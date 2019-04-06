//
//  UploadResponceDataModel.swift
//  Tebsbot
//
//  Created by uvionics on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation

struct UploadResponceDataModel : Codable {
    let data : claimData?
    let message : String?
    let flag : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case message = "message"
        case flag = "flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(claimData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        flag = try values.decodeIfPresent(Bool.self, forKey: .flag)
    }
    
}
struct claimData : Codable {
    let status : Int?
    let data : Data?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent(Data.self, forKey: .data)
    }
    
}
