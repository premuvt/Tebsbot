

import Foundation
struct LeaveConfirmModel : Codable {
	let data : Int?
	let message : String?
	let flag : Bool?

	enum CodingKeys: String, CodingKey {

		case data = "data"
		case message = "message"
		case flag = "flag"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		data = try values.decodeIfPresent(Int.self, forKey: .data)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		flag = try values.decodeIfPresent(Bool.self, forKey: .flag)
	}

}
