//
//  DWOTransactionsRequest.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/1/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransactionsRequest.h"
// models
#import "DWOBoolSearchOption.h"
// constants
#import "DWORestApiConstants.h"

@implementation DWOTransactionsRequest

- (NSArray *)types {
    if (!_types) {
        _types = @[
                   [[DWOBoolSearchOption alloc] initWithIdentifier:kDWOTransactionTypeMoneySent name:@"Sent" enabled:YES],
                   [[DWOBoolSearchOption alloc] initWithIdentifier:kDWOTransactionTypeMoneyReceived name:@"Received" enabled:YES],
                   [[DWOBoolSearchOption alloc] initWithIdentifier:kDWOTransactionTypeWithdrawal name:@"Withdrawal" enabled:YES],
                   [[DWOBoolSearchOption alloc] initWithIdentifier:kDWOTransactionTypeDeposit name:@"Deposit" enabled:YES],
                   [[DWOBoolSearchOption alloc] initWithIdentifier:kDWOTransactionTypeFee name:@"Fee" enabled:NO],
                   ];
    }
    
    return _types;
}

@end
