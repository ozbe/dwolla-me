//
//  DWOFundingSource+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/10/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWOFundingSource.h"

@interface DWOFundingSource (Dwolla)

- (BOOL)isBalance;
- (BOOL)isBalancedFundingSource;

@end
