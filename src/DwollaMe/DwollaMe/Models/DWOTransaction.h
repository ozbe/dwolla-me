//
//  DWOTransaction.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

typedef enum : NSInteger {
    DWOTransactionTypeUnknown,
    DWOTransactionTypeMoneyReceived,
    DWOTransactionTypeMoneySent,
    DWOTransactionTypeDeposit,
    DWOTransactionTypeWithdrawal,
    DWOTransactionTypeFee
} DWOTransactionType;

typedef enum : NSInteger {
    DWOTransactionStatusCompleted,
    DWOTransactionStatusPending,
    DWOTransactionStatusProcessed,
    DWOTransactionStatusFailed,
    DWOTransactionStatusCancelled,
    DWOTransactionStatusReclaimed,
    DWOTransactionStatusUnknown
} DWOTransactionStatus;

@interface DWOTransaction : NSObject

@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) DWOTransactionType type;
@property (nonatomic, assign) DWOTransactionStatus status;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *clearingDate;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSArray *fees;

@end
