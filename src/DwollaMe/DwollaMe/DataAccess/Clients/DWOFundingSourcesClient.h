//
//  FundingSourcesClient.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// data access
#import "DWORestClient.h"
// models
#import "DWOTransaction.h"
#import "DWOFundRequest.h"
#import "DWODestination.h"

@interface DWOFundingSourcesClient : DWORestClient

- (NSArray *)fundingSourcesOrError:(NSError **)error;
- (NSArray *)fundingSourcesForDestination:(DWODestination *)destination error:(NSError **)error;
- (NSNumber *)balanceForFundingSourceId:(NSString *)fundingSourceId error:(NSError **)error;
- (DWOTransaction *)deposit:(DWOFundRequest *)request error:(NSError **)error;
- (DWOTransaction *)withdraw:(DWOFundRequest *)request error:(NSError **)error;
// add
// verify

@end
