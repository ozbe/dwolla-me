//
//  DwollaCredentials.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/16/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOCredentials.h"
// vendors
#import "SSKeychain.h"
// constants
#import "DWORestApiConstants.h"

@implementation DWOCredentials

#define KEYCHAIN_SERVICE_TOKEN @"token"
#define KEYCHAIN_ACCOUNT_NAME @"DwollaMe"

@synthesize token = _token;

static DWOCredentials *_sharedCredentials;

+ (DWOCredentials *)sharedCredentials {
    if (!_sharedCredentials) {
        _sharedCredentials = [[DWOCredentials alloc] init];
    }
    return _sharedCredentials;
}

- (NSString *)token {
    if (!_token) {
        _token = [SSKeychain passwordForService:KEYCHAIN_SERVICE_TOKEN account:KEYCHAIN_ACCOUNT_NAME];
    }
    
    return _token;
}

- (void)setToken:(NSString *)token {
    _token = token;
    
    [self storeToken:_token];
}

- (NSString *)baseUrl {
    return kDWOBaseUrlTest;
}

- (void)storeToken:(NSString *)token {
    if (!token) {
        [SSKeychain deletePasswordForService:KEYCHAIN_SERVICE_TOKEN account:KEYCHAIN_ACCOUNT_NAME];
    } else {
        [SSKeychain setPassword:token forService:KEYCHAIN_SERVICE_TOKEN account:KEYCHAIN_ACCOUNT_NAME];
    }
}

@end
