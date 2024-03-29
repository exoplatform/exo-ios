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


#import "SocialSpace.h"

@implementation SocialSpace
@synthesize avatarUrl, groupId, spaceId, name, displayName, url, spaceUrl;
-(void) requestForSpaceId {
    NSString * path = [NSString stringWithFormat:@"private/api/social/v1-alpha3/portal/identity/space/%@.json", self.name];
		path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}
-(NSString *) description {
    return [NSString stringWithFormat:@"[name : %@] [url : %@] [id : %@]", self.name, self.url, self.spaceId];
}

@end
