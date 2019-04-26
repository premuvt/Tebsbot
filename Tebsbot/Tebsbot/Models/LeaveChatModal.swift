//
//  LeaveChatModal.swift
//  Tebsbot
//
//  Created by Premraj C Ramankutty on 05/04/19.
//  Copyright © 2019 Premraj C Ramankutty. All rights reserved.
//

import Foundation
struct LeaveChatModal : Codable {
    var data : LeaveData?
    let message : String?
    let flag : Bool?
    var receivedDate = Date()
    var sendDate = Date()
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case message = "message"
        case flag = "flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(LeaveData.self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        flag = try values.decodeIfPresent(Bool.self, forKey: .flag)
    }
    
}
struct LeaveData : Codable {
    let start : String?
    let reason : String?
    let final_flag : Int?
    let query : String?
    let sentence : String?
    let leave : String?
    let type : String?
    let date : String?
    let from_date : String?
    let end_date : String?
    let date_flag : String?
    let type_flag : String?
    let reason_flag : String?
    let doc_flag : String?
    
    enum CodingKeys: String, CodingKey {
        
        case start = "start"
        case reason = "reason"
        case final_flag = "final_flag"
        case query = "query"
        case sentence = "Sentence"
        case leave = "Leave"
        case type = "type"
        case date = "Date"
        case from_date = "from_date"
        case end_date = "end_date"
        case date_flag = "date_flag"
        case type_flag = "type_flag"
        case reason_flag = "reason_flag"
        case doc_flag = "doc_flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        start = try values.decodeIfPresent(String.self, forKey: .start)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        final_flag = try values.decodeIfPresent(Int.self, forKey: .final_flag)
        query = try values.decodeIfPresent(String.self, forKey: .query)
        sentence = try values.decodeIfPresent(String.self, forKey: .sentence)
        leave = try values.decodeIfPresent(String.self, forKey: .leave)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        from_date = try values.decodeIfPresent(String.self, forKey: .from_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        date_flag = try values.decodeIfPresent(String.self, forKey: .date_flag)
        type_flag = try values.decodeIfPresent(String.self, forKey: .type_flag)
        reason_flag = try values.decodeIfPresent(String.self, forKey: .reason_flag)
        doc_flag = try values.decodeIfPresent(String.self, forKey: .doc_flag)
    }
    
}
