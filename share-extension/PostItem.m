//
// Copyright (C) 2003-2015 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//


#import "PostItem.h"
#import "HTMLKit.h"

@implementation PostItem

-(id) init {
	self = [super init];
	if (self){
		self.uploadStatus = eXoItemStatusReadyToUpload;
		self.isImageItem = NO;
	}
	return self;
}


/*
 Make the file upload name on server side
 fileAttacheName = mobile + [datetime string] + [converted filename]
 converted rules:
 - No upper case
 - No special characters
 - No space or -,_
 */
#define REGEXP_SEPARATOR @"[_: ]"
#define REGEXP_2TIME_SPEPARATOR @"-{2,}"
#define REGEXP_REMOVE_CHAR @"[{}()!@#$%^&|;\"~`'<>?\\/,+=*.ˆ\\[\\]]"

-(NSString *) generateUploadFileName {
	NSData * tmp = [self.fileExtension dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString * name = [[NSString alloc] initWithData:tmp encoding:NSASCIIStringEncoding];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
	NSString * fileAttachName = [dateFormatter stringFromDate:[NSDate date]];
	NSString * extension;
	NSRange range;
	range = [name rangeOfString:@"." options:NSBackwardsSearch];
	if (range.location!=NSNotFound){
		extension = [name substringFromIndex:range.location];
		name = [name substringToIndex:range.location];
	}
	while ((range = [name rangeOfString:REGEXP_REMOVE_CHAR options:NSRegularExpressionSearch]).location != NSNotFound) {
		name = [name stringByReplacingCharactersInRange:range withString:@""];
	}
	while ((range = [name rangeOfString:REGEXP_SEPARATOR options:NSRegularExpressionSearch]).location != NSNotFound) {
		name = [name stringByReplacingCharactersInRange:range withString:@"-"];
	}
	while ((range = [name rangeOfString:REGEXP_2TIME_SPEPARATOR options:NSRegularExpressionSearch]).location != NSNotFound) {
		name = [name stringByReplacingCharactersInRange:range withString:@"-"];
	}

	name = [name lowercaseString];
	name = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
	if (extension){
		fileAttachName = [NSString stringWithFormat:@"mobile-%@-%@%@",fileAttachName,name,extension];
	} else {
		fileAttachName = [NSString stringWithFormat:@"mobile-%@.%@",fileAttachName,name];
	}
	return fileAttachName;
}


#pragma mark - link activity

-(void) extractMetadata {
	NSURLSession *session = [NSURLSession sharedSession];

	[[session dataTaskWithURL:self.url
					completionHandler:^(NSData *data,
															NSURLResponse *response,
															NSError *error) {

						NSString * pagesource = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
						HTMLDocument * htmlDoc = [HTMLDocument documentWithString:pagesource];
						if (htmlDoc) {
							// Page title
							self.pageWebTitle = [self getTitle:htmlDoc];
							// Page description or excerpt
							self.pageDescription = [self getDescription:htmlDoc];
							// Description image or logo
							self.imageURLFromLink = [self getImageUrl:htmlDoc];
						}
					}] resume];
}

- (NSString*) getTitle:(nonnull HTMLDocument *)htmlDoc {
	NSString * title = @"";
	if (htmlDoc.head) {
		// Try the 'meta og:title' element
		HTMLElement * titleElt = [htmlDoc.head querySelector:@"meta[property='title']"];
		if (titleElt && [titleElt hasAttribute:@"content"]) {
			title = [titleElt.attributes valueForKey:@"content"];
		} else {
			// Try the 'title' element
			titleElt = [htmlDoc.head querySelector:@"title"];
			if (titleElt)
				title = titleElt.textContent;
		}
	}
	return title;
}

- (NSString*) getDescription:(nonnull HTMLDocument *)htmlDoc {
	NSString * desc = @"";
	if (htmlDoc.head) {
		// Try the 'meta og:description' element
		HTMLElement * metaOgDesc = [htmlDoc.head querySelector:@"meta[property='og:description']"];
		if (metaOgDesc && [metaOgDesc hasAttribute:@"content"]) {
			desc = [metaOgDesc.attributes valueForKey:@"content"];
		} else {
			// Try the 'meta description' element
			metaOgDesc = [htmlDoc.head querySelector:@"meta[name='description']"];
			if (metaOgDesc && [metaOgDesc hasAttribute:@"content"])
				desc = [metaOgDesc.attributes valueForKey:@"content"];
		}
	}
	// Try the first paragraph of text, clipped at 250 characters
	if ([desc isEqualToString:@""] && htmlDoc.body) {
		HTMLElement * content = [self findContainerElement:htmlDoc];
		if (content) {
			NSArray * paragraphs = [content querySelectorAll:@"p"];
			for (HTMLElement * paragraph in paragraphs) {
				if (![paragraph.textContent isEqualToString:@""]) {
					NSString * text = paragraph.textContent;
					desc = text.length > 250
					? [NSString stringWithFormat:@"%@...", [text substringToIndex:250]]
					: text;
					break;
				}
			}
		}
	}
	return desc;
}

- (NSString*) getImageUrl:(nonnull HTMLDocument *)htmlDoc {
	NSString * imageUrl = @"";
	if (htmlDoc.head) {
		// Try the 'meta og:image' element
		HTMLElement * metaOgImage = [htmlDoc.head querySelector:@"meta[property='og:image']"];
		if (metaOgImage && [metaOgImage hasAttribute:@"content"])
			imageUrl = [metaOgImage.attributes valueForKey:@"content"];
	}
	// Try the first image that appears in content
	if ([imageUrl isEqualToString:@""] && htmlDoc.body) {
		HTMLElement * content = [self findContainerElement:htmlDoc];
		if (content) {
			HTMLElement * imageElt = [content querySelector:@"img[src^='http']"];
			if (imageElt)
				imageUrl = [imageElt.attributes valueForKey:@"src"];
		}
	}
	return imageUrl;
}


- (HTMLElement*) findContainerElement:(nonnull HTMLDocument *)htmlDoc {
	if (htmlDoc.body) {
		// Try the 'container' css class
		HTMLElement * container = [htmlDoc.body querySelector:@".container"];
		if (container) return container;
		// Try the 'content' css class
		container = [htmlDoc querySelector:@".content"];
		if (container) return container;
		// Try the 'article-page' css class
		container = [htmlDoc querySelector:@".article-page"];
		if (container) return container;
		// Try the 'article' css class
		container = [htmlDoc querySelector:@".article"];
		if (container) return container;
		// Try the 'entry-content' css class
		container = [htmlDoc querySelector:@".entry-content"];
		if (container) return container;
		// Try the 'site-content' css class
		container = [htmlDoc querySelector:@".site-content"];
		if (container) return container;
		// Try the 'article' element
		container = [htmlDoc querySelector:@"article"];
		if (container) return container;
		// Try the 'main' element
		container = [htmlDoc querySelector:@"main"];
		if (container) return container;
		// Try the '' css class / element
		//        container = [htmlDoc querySelector:@""];
		//        if (container) return container;
	}
	return nil;
}

@end
