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

#import "AccountManager.h"
#import "extension-defines.h"
#import "Account.h"
#import "UICKeyChainStore.h"

@implementation AccountManager

@synthesize allAccounts, selectedAccount;

+ (AccountManager * )sharedManager {
    static AccountManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(id) init {
    self = [super init];
    if (self) {
        allAccounts = [self allAccountsFromNSUserDefault];
        if (allAccounts && allAccounts.count >0) {
            selectedAccount = allAccounts[0];
        }
    }
    return self;
}

/*
 Get all account which has ever logged in eXo Application.
 The list of account will be share between eXo Application & eXo Share Extension via the share NSUserDefaults.
 Each Account is stored in NSUserDefaults as a Dictionay of 4 keys: username, password, serverURL & accountName.
 There is a selected Account (which is the last logged account in the eXo Application.
 */

-(NSMutableArray *) allAccountsFromNSUserDefault {
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: SHARE_EXTENSION_USERDEFAULT_SUITE];

    NSArray * list =[mySharedDefaults valueForKey:EXO_SHARE_EXTENSION_ALL_ACCOUNTS];
    if (!list) {
        return [NSMutableArray init];
    }
    NSMutableArray * accounts = [[NSMutableArray alloc] init];
    for (NSDictionary * dict in list) {
        Account * account = [[Account alloc] init];
        account.userName = [dict objectForKey:@"username"];
        account.serverURL = [dict objectForKey:@"serverURL"];
        if (account.serverURL && [account.serverURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length >0){
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:account.serverURL] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
            if (keychain && keychain[@"username"] && keychain[@"password"]){
                if (!account.userName || [account.userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length ==0){
                    account.userName = keychain[@"username"];
                    if (account.userName) {
                        account.password = keychain[@"password"];
                    }
                } else {
                    if ([account.userName isEqualToString:keychain[@"username"]]){
                        account.password = keychain[@"password"];
                    }
                }
            }
            [accounts addObject:account];
        }
    }
    return accounts;
}

-(void) saveAccounts {

    for (Account * a in allAccounts) {
        if (a.serverURL && a.userName && a.password && a.userName.length >0 && a.password.length >0 ){
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:a.serverURL] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
            if (keychain){
                keychain[@"username"] = a.userName;
                keychain[@"password"] = a.password;
            }
        }
    }
}

@end
