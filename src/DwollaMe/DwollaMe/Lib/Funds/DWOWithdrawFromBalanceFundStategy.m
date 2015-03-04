//
//  DWOWithdrawFromBalanceFundStategy.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOWithdrawFromBalanceFundStategy.h"
// data access
#import "DWOFundingSourcesClient.h"

@interface DWOWithdrawFromBalanceFundStategy ()
@property (nonatomic, strong) DWOFundingSourcesClient *fundingSourcesClient;
@end

@implementation DWOWithdrawFromBalanceFundStategy

#pragma mark - Properties

- (DWOFundingSourcesClient *)fundingSourcesClient {
    if (!_fundingSourcesClient) {
        _fundingSourcesClient = [[DWOFundingSourcesClient alloc] init];
    }
    return _fundingSourcesClient;
}

#pragma mark - Public

- (NSString *)submitTitle {
    return @"Withdraw";
}

- (DWOTransaction *)submitRequest:(DWOFundRequest *)request error:(NSError **)error {
    return [self.fundingSourcesClient withdraw:request error:error];
}

@end
