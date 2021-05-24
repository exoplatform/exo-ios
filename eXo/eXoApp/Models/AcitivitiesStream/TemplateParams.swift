

import Foundation

struct TemplateParams : Codable {
    
	let thumbnail : String?
	let workspace : String?
	let author : String?
	let contenLink : String?
	let nodePath : String?
	let mimeType : String?
	let message : String?
	let repository : String?
	let nodeUUID : String?
	let contentName : String?
	let isSystemComment : String?
	let dateCreated : String?
	let id : String?
	let lastModified : String?

	enum CodingKeys: String, CodingKey {
		case thumbnail = "thumbnail"
		case workspace = "workspace"
		case author = "author"
		case contenLink = "contenLink"
		case nodePath = "nodePath"
		case mimeType = "mimeType"
		case message = "message"
		case repository = "repository"
		case nodeUUID = "nodeUUID"
		case contentName = "contentName"
		case isSystemComment = "isSystemComment"
		case dateCreated = "dateCreated"
		case id = "id"
		case lastModified = "lastModified"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
		workspace = try values.decodeIfPresent(String.self, forKey: .workspace)
		author = try values.decodeIfPresent(String.self, forKey: .author)
		contenLink = try values.decodeIfPresent(String.self, forKey: .contenLink)
		nodePath = try values.decodeIfPresent(String.self, forKey: .nodePath)
		mimeType = try values.decodeIfPresent(String.self, forKey: .mimeType)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		repository = try values.decodeIfPresent(String.self, forKey: .repository)
		nodeUUID = try values.decodeIfPresent(String.self, forKey: .nodeUUID)
		contentName = try values.decodeIfPresent(String.self, forKey: .contentName)
		isSystemComment = try values.decodeIfPresent(String.self, forKey: .isSystemComment)
		dateCreated = try values.decodeIfPresent(String.self, forKey: .dateCreated)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		lastModified = try values.decodeIfPresent(String.self, forKey: .lastModified)
	}
    
}
  
