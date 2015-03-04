//
//  DWOMoneyRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/30/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// models
#import "DWOAccount.h"

typedef enum : NSInteger {
    DWOMoneyRequestStatusUnknown,
    DWOMoneyRequestStatusPending,
    DWOMoneyRequestStatusPaid,
    DWOMoneyRequestStatusCancelled
} DWOMoneyRequestStatus;

@interface DWOMoneyRequest : NSObject

@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSDate *requested;
@property (nonatomic, assign) DWOMoneyRequestStatus status;
@property (nonatomic, strong) DWOAccount *source;
@property (nonatomic, strong) DWOAccount *destination;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSDate *cancelled;
@property (nonatomic, assign) BOOL senderAssumeFee;
@property (nonatomic, assign) BOOL senderAssumeAdditonalFees;
// DWOMoneyRequestFee
@property (nonatomic, strong) NSArray *additionalFees;

@end
