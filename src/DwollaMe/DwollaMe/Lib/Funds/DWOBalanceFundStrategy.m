//
//  DWOBalanceFundStrategy.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOBalanceFundStrategy.h"

@implementation DWOBalanceFundStrategy

- (NSString *)submitTitle {
    return nil;
}

- (BOOL)isValidRequest:(DWOFundRequest *)request {
    return request.fundingSourceId.length &&
        request.pin.length == 4 &&
        [request.amount doubleValue] > 0;
}

- (BOOL)isValidFundingSource:(DWOFundingSource *)fundingSource {
    return fundingSource.processingType.length;
}

- (DWOTransaction *)submitRequest:(DWOFundRequest *)request error:(NSError **)error {
    return nil;
}

@end
