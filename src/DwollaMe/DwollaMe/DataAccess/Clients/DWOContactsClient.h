//
//  DWOContactsClient.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// data access
#import "DWORestClient.h"
// models
#import "DWOUserSearchFilterOptions.h"
#import "DWONearbyContactsRequest.h"
#import "DWOContactSearchRequest.h"

@interface DWOContactsClient : DWORestClient

- (NSArray *)searchContacts:(DWOContactSearchRequest *)request error:(NSError **)error;
- (NSArray *)contactsNearby:(DWONearbyContactsRequest *)request error:(NSError **)error;

@end
