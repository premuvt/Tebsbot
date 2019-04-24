import Foundation
struct MyLeaveListModal : Codable {
    let data : [Data]?
    let message : String?
    let flag : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case message = "message"
        case flag = "flag"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Data].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        flag = try values.decodeIfPresent(Bool.self, forKey: .flag)
    }
    
}
struct Data : Codable {
    let id : Int?
    let leaveType : String?
    let startDate : String?
    let endDate : String?
    let reason : String?
    let username : String?
    let attachementUrl : String?
    let leaveStatus : String?
    let duration : Int?
    let appliedDateTime : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case leaveType = "leaveType"
        case startDate = "startDate"
        case endDate = "endDate"
        case reason = "reason"
        case username = "username"
        case attachementUrl = "attachementUrl"
        case leaveStatus = "leaveStatus"
        case duration = "duration"
        case appliedDateTime = "appliedDateTime"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        leaveType = try values.decodeIfPresent(String.self, forKey: .leaveType)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        attachementUrl = try values.decodeIfPresent(String.self, forKey: .attachementUrl)
        leaveStatus = try values.decodeIfPresent(String.self, forKey: .leaveStatus)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        appliedDateTime = try values.decodeIfPresent(Int.self, forKey: .appliedDateTime)
    }
    
}
