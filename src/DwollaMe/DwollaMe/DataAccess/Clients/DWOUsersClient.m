//
//  DWOUsersClient.m
//  DwollaMe
//
//  Created by Josh Aaseby on 1/14/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// header
#import "DWOUsersClient.h"
// constants
#import "DWORestApiConstants.h"

@implementation DWOUsersClient

#pragma mark - Public

- (DWOUser *)userOrError:(NSError **)error {
    return [self getRelativePath:kDWORelativePathUsers addParameters:^(NSMutableDictionary *parameters) {
        [parameters setObject:self.credentials.token forKey:kDWORequestKeyOAuthToken];
    } convertResponse:^id(id response) {
        return [self userFromDictionary:response];
    } error:error];
}

- (BOOL)isTokenValid {
#warning use userOrError
    NSError *error;
    NSDictionary *rawUser = [self getRelativePath:kDWORelativePathUsers
                                   withParameters:@{
                                                       kDWORequestKeyOAuthToken: self.credentials.token
                                                   }
                                            error:&error];
    
    return ![[rawUser objectForKey:kDWOResponseKeyMessage] isEqualToString:@"Invalid access token."];
}

#pragma mark - Private

- (DWOUser *)userFromDictionary:(NSDictionary *)dictionary {
    DWOUser *user = [[DWOUser alloc] init];
    user.accountId = [dictionary objectForKey:kDWOResponseKeyAccountId];
    user.city = [dictionary objectForKey:kDWOResponseKeyAccountCity];
    user.name = [dictionary objectForKey:kDWOResponseKeyAccountName];
    user.state = [dictionary objectForKey:kDWOResponseKeyAccountState];
    user.type = [dictionary objectForKey:kDWOResponseKeyAccountType];
    
    double latitude = [[dictionary objectForKey:kDWOResponseKeyAccountLatitude] doubleValue];
    double longitude = [[dictionary objectForKey:kDWOResponseKeyAccountLongitude] doubleValue];
    user.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    return user;
}

@end
