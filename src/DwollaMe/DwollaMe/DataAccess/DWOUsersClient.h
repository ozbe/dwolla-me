//
//  DWOUsersClient.h
//  DwollaMe
//
//  Created by Josh Aaseby on 1/14/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// data access
#import "DWORestClient.h"
// models
#import "DWOUser.h"

@interface DWOUsersClient : DWORestClient

- (DWOUser *)userOrError:(NSError **)error;
- (BOOL)isTokenValid;

@end
