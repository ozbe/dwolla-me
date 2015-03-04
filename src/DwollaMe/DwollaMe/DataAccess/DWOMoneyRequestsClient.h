//
//  DWORequestsClient.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// data access
#import "DWORestClient.h"
// models
#import "DWOMoneyRequestsRequest.h"
#import "DWOFulfillMoneyRequest.h"
#import "DWOFulfillResponse.h"
#import "DWORequestResponse.h"
#import "DWORequest.h"

@interface DWOMoneyRequestsClient : DWORestClient

- (NSArray *)moneyRequests:(DWOMoneyRequestsRequest *)request error:(NSError **)error;
- (void)cancelRequest:(NSString *)requestId error:(NSError **)error;
- (DWOFulfillResponse *)fulfillRequest:(DWOFulfillMoneyRequest *)request error:(NSError **)error;
- (DWORequestResponse *)request:(DWORequest *)request error:(NSError **)error;
// details

@end
