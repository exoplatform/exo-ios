//
//  AccountManager.m
//  eXo
//
//  Created by Nguyen Manh Toan on 10/29/15.
//  Copyright © 2015 eXo. All rights reserved.
//

#import "AccountManager.h"
#import "extension-defines.h"
#import "Account.h"
#import "UICKeyChainStore.h"

@implementation AccountManager

@synthesize allAccount, selectedAccount;

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
        allAccount = [self allAccountFromNSUserDefault];
        if (allAccount && allAccount.count >0) {
            selectedAccount = allAccount[0];
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

-(NSMutableArray *) allAccountFromNSUserDefault {
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
        if (account.serverURL && account.serverURL.length >0){
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithServer:[NSURL URLWithString:account.serverURL] protocolType:UICKeyChainStoreProtocolTypeHTTPS];
            if (keychain && keychain[@"username"] && keychain[@"password"]){
                if (!account.userName || account.userName.length ==0){
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

    for (Account * a in allAccount) {
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
