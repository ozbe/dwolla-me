//
//  NSString+DWOTransaction.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/23/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "NSString+DWOTransaction.h"
// constants
#import "DWORestApiConstants.h"

@implementation NSString (DWOTransaction)

- (DWOTransactionStatus)convertToTransactionStatus {
    if ([self isEqualToString:kDWOTransactionStatusCancelled]){
        return DWOTransactionStatusCancelled;
    } else if ([self isEqualToString:kDWOTransactionStatusCompleted]) {
        return DWOTransactionStatusCompleted;
    } else if ([self isEqualToString:kDWOTransactionStatusFailed]) {
        return DWOTransactionStatusFailed;
    } else if ([self isEqualToString:kDWOTransactionStatusPending]) {
        return DWOTransactionStatusPending;
    } else if ([self isEqualToString:kDWOTransactionStatusProcessed]) {
        return DWOTransactionStatusProcessed;
    } else if ([self isEqualToString:kDWOTransactionStatusReclaimed]) {
        return DWOTransactionStatusReclaimed;
    } else {
        return DWOTransactionStatusUnknown;
    }
}

@end
