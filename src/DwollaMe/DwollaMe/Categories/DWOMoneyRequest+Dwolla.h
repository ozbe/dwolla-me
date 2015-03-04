//
//  DWOMoneyRequest+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWOMoneyRequest.h"
// lib
#import "DWOFulfillMoneyRequestStategy.h"

@interface DWOMoneyRequest (Dwolla)

- (DWOFulfillMoneyRequestStategy *)convertToFulfillMoneyRequestStrategy;

@end
