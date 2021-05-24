

import Foundation

struct BaseActivityStreamResponse : Codable {
    
	let activities : [Activities]?
	let offset : Int?
	let limit : Int?

	enum CodingKeys: String, CodingKey {
		case activities = "activities"
		case offset = "offset"
		case limit = "limit"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		activities = try values.decodeIfPresent([Activities].self, forKey: .activities)
		offset = try values.decodeIfPresent(Int.self, forKey: .offset)
		limit = try values.decodeIfPresent(Int.self, forKey: .limit)
	}

}
