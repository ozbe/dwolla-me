//
//  Transaction+Display.m
//  DwollaMe
//
//  Created by Josh Aaseby on 1/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOTransaction+Display.h"

@implementation DWOTransaction (Display)

- (NSString *)displayStatus {
    switch (self.status) {
        case DWOTransactionStatusCancelled:
            return @"Cancelled";
        case DWOTransactionStatusFailed:
            return @"Failed";
        case DWOTransactionStatusCompleted:
            return @"Completed";
        case DWOTransactionStatusPending:
            return @"Pending";
        case DWOTransactionStatusProcessed:
            return @"Processed";
        case DWOTransactionStatusReclaimed:
            return @"Reclaimed";
        default:
            return nil;
    }
}

- (NSString *)displayType {
    switch (self.type) {
        case DWOTransactionTypeDeposit:
            return @"Deposit";
        case DWOTransactionTypeMoneyReceived:
            return @"Received";
        case DWOTransactionTypeFee:
            return @"Fee";
        case DWOTransactionTypeMoneySent:
            return @"Sent";
        case DWOTransactionTypeWithdrawal:
            return @"Withdrawal";
        case DWOTransactionTypeUnknown:
        default:
            return nil;
    }
    
}

@end
