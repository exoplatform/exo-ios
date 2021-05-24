
import Foundation

struct ActivityStream : Codable {
    
	let type : String?
	let id : String?

	enum CodingKeys: String, CodingKey {
		case type = "type"
		case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}

}
