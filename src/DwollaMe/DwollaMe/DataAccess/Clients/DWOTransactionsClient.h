//
//  DWOTransactionsClient.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// data access
#import "DWORestClient.h"
// models
#import "DWOTransactionsRequest.h"
#import "DWOSendRequest.h"
#import "DWOSendResponse.h"

@interface DWOTransactionsClient : DWORestClient

- (NSArray *)transactions:(DWOTransactionsRequest *)request error:(NSError **)error;
- (DWOSendResponse *)send:(DWOSendRequest *)request error:(NSError **)error;

@end
