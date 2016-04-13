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


#import <Foundation/Foundation.h>
#import "HTMLKit.h"
#import <UIKit/UIKit.h>


@interface PostItem : NSObject <UIWebViewDelegate>
enum {
    eXoItemStatusReadyToUpload = 0,
    eXoItemStatusUploadSuccess = 1,
    eXoItemStatusUploadFailed = -1,
    eXoItemStatusUploadFileTooLarge = -2,
};
// DEFAULT_ACTIVITY for a simple text activities
// LINK_ACTIVITY for shared links
// DOC_ACTIVITY for shared documents
@property (nonatomic, retain) NSString * type;

// Can be URL in LINK_ACTIVITY, FileURL or NSData for DOC_ACTIVITY
@property (nonatomic, retain) NSURL * url;

// In DOC_ACTIVITY only
@property (nonatomic, retain) NSData * fileData;
@property (nonatomic, retain) NSString * fileExtension;

// In LINK_ACTIVITY only
@property (nonatomic, retain) NSString * pageWebTitle;
@property (nonatomic, retain) NSString * pageDescription;
@property (nonatomic, retain) NSString * imageURLFromLink;

@property (nonatomic) int uploadStatus;
@property (nonatomic) int isImageItem;
// After upload
@property (nonatomic, retain) NSString * fileUploadedURL;
@property (nonatomic, retain) NSString * fileUploadedName;

-(id) init;

-(NSString *) generateUploadFileName ;

#pragma mark - link activity
-(void) extractMetadata;

@end
