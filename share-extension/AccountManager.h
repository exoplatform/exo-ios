//
//  AccountManager.h
//  eXo
//
//  Created by Nguyen Manh Toan on 10/29/15.
//  Copyright © 2015 eXo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
@interface AccountManager : NSObject


+ (AccountManager *)sharedManager;
- (void) saveAccounts;

@property (nonatomic, retain) NSMutableArray * allAccount;

@property (nonatomic, retain) Account * selectedAccount;

@end
