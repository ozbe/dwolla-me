//
//  DWODepositToBalanceFundStrategy.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWODepositToBalanceFundStrategy.h"
// data access
#import "DWOFundingSourcesClient.h"

@interface DWODepositToBalanceFundStrategy ()
@property (nonatomic, strong) DWOFundingSourcesClient *fundingSourcesClient;
@end

@implementation DWODepositToBalanceFundStrategy

#pragma mark - Properties

- (DWOFundingSourcesClient *)fundingSourcesClient {
    if (!_fundingSourcesClient) {
        _fundingSourcesClient = [[DWOFundingSourcesClient alloc] init];
    }
    return _fundingSourcesClient;
}

#pragma mark - Public

- (NSString *)submitTitle {
    return @"Deposit";
}

- (DWOTransaction *)submitRequest:(DWOFundRequest *)request error:(NSError **)error {
    return [self.fundingSourcesClient deposit:request error:error];
}

@end
