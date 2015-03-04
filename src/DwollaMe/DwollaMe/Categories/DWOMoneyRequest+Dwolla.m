//
//  DWOMoneyRequest+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOMoneyRequest+Dwolla.h"

@implementation DWOMoneyRequest (Dwolla)

- (DWOFulfillMoneyRequestStategy *)convertToFulfillMoneyRequestStrategy {
    DWOFulfillMoneyRequestStategy *fulfillMoneyRequestStrategy = [[DWOFulfillMoneyRequestStategy alloc] init];
    fulfillMoneyRequestStrategy.fulfillMoneyRequest.requestId = self.requestId;
    fulfillMoneyRequestStrategy.destinationId = self.source.accountId;
    fulfillMoneyRequestStrategy.destinationType = self.source.type;
    fulfillMoneyRequestStrategy.imageUrl = self.source.imageUrl;
    fulfillMoneyRequestStrategy.name = self.source.name;
    fulfillMoneyRequestStrategy.amount = self.amount;
    return fulfillMoneyRequestStrategy;
}

@end
