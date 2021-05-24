

import Foundation

struct Activities : Codable {
    
	let id : String?
	let title : String?
	let type : String?
	let templateParams : TemplateParams?
	let href : String?
	let identity : String?
	let owner : Owner?
	let mentions : [Mentions]?
	let attachments : [String]?
	let comments : String?
	let likes : String?
	let createDate : String?
	let updateDate : String?
	let activityStream : ActivityStream?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case type = "type"
		case templateParams = "templateParams"
		case href = "href"
		case identity = "identity"
		case owner = "owner"
		case mentions = "mentions"
		case attachments = "attachments"
		case comments = "comments"
		case likes = "likes"
		case createDate = "createDate"
		case updateDate = "updateDate"
		case activityStream = "activityStream"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		templateParams = try values.decodeIfPresent(TemplateParams.self, forKey: .templateParams)
		href = try values.decodeIfPresent(String.self, forKey: .href)
		identity = try values.decodeIfPresent(String.self, forKey: .identity)
		owner = try values.decodeIfPresent(Owner.self, forKey: .owner)
		mentions = try values.decodeIfPresent([Mentions].self, forKey: .mentions)
		attachments = try values.decodeIfPresent([String].self, forKey: .attachments)
		comments = try values.decodeIfPresent(String.self, forKey: .comments)
		likes = try values.decodeIfPresent(String.self, forKey: .likes)
		createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
		updateDate = try values.decodeIfPresent(String.self, forKey: .updateDate)
		activityStream = try values.decodeIfPresent(ActivityStream.self, forKey: .activityStream)
	}

}
