
import Foundation

struct Mentions : Codable {
    
	let id : String?
	let href : String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case href = "href"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		href = try values.decodeIfPresent(String.self, forKey: .href)
	}

}
