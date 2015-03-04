//
//  DWOFundingSource+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/10/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOFundingSource+Dwolla.h"
// constants
#import "DWORestApiConstants.h"

@implementation DWOFundingSource (Dwolla)

- (BOOL)isBalance {
    return [self.fundingSourceId caseInsensitiveCompare:kDWOFundingSourceIdBalance] == NSOrderedSame;
}

- (BOOL)isBalancedFundingSource {
    return ![self.processingType isEqualToString:@"ACH"];
}

@end
