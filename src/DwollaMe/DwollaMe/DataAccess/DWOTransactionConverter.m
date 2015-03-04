//
//  DWOTransactionConverter.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransactionConverter.h"
// data access
#import "DWODateFormatter.h"
// models
#import "DWOTransactionFee.h"
// constants
#import "DWORestApiConstants.h"
// categories
#import "NSString+DWOTransaction.h"

@implementation DWOTransactionConverter

#pragma mark - Static

static DWODateFormatter *_dateFormatter;

+ (DWODateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[DWODateFormatter alloc] init];
    }
    return _dateFormatter;
}

#pragma mark - Properties

- (NSString *)baseUrl {
    if (!_baseUrl) {
        _baseUrl = kDWOBaseUrlProd;
    }
    return _baseUrl;
}

#pragma mark - Public

- (DWOTransaction *)convertFromDictionary:(NSDictionary *)dictionary {
    DWOTransactionType type = [self typeForTransaction:dictionary];
    NSString *userType = [dictionary objectForKey:kDWOResponseKeyTransactionUserType];
    NSString *name, *userId;
    [self transaction:dictionary type:type name:&name userId:&userId];
    
    NSArray *fees = [self feesForTransaction:dictionary];
    
    DWOTransaction *transaction = [[DWOTransaction alloc] init];
    transaction.transactionId = [dictionary objectForKey:kDWOResponseKeyTransactionId];
    transaction.name = name;
    transaction.userId = userId;
    transaction.type = type;
    transaction.status = [self statusForTransaction:dictionary];
    transaction.date = [self dateForTransaction:dictionary];
    transaction.clearingDate = [self clearingDateForTransaction:dictionary];
    transaction.amount = [self amountForTransaction:dictionary];
    transaction.notes = [self notesForTransaction:dictionary];
    transaction.imageUrl = [self imageUrlForUserId:userId userType:userType];
    transaction.fees = fees;
    return transaction;
}

#pragma mark - Private

- (NSDate *)clearingDateForTransaction:(NSDictionary *)transaction {
    return [[DWOTransactionConverter dateFormatter] dateFromLongString:[transaction objectForKey:kDWOResponseKeyTransactionClearingDate]];
}

- (NSDate *)dateForTransaction:(NSDictionary *)transaction {
    return [[DWOTransactionConverter dateFormatter] dateFromLongString:[transaction objectForKey:kDWOResponseKeyTransactionDate]];
}

- (NSString *)notesForTransaction:(NSDictionary *)transaction {
    id notes = [transaction objectForKey:kDWOResponseKeyTransactionNotes];
    return ([notes isKindOfClass:[NSString class]]) ? notes : nil;
}

- (DWOTransactionStatus)statusForTransaction:(NSDictionary *)transaction {
    NSString *rawStatus = [transaction objectForKey:kDWOResponseKeyTransactionStatus];
    
    return [rawStatus convertToTransactionStatus];
}

- (void)transaction:(NSDictionary *)transaction type:(DWOTransactionType)type name:(NSString **)name userId:(NSString **)userId {
    if (type == DWOTransactionTypeMoneyReceived || type == DWOTransactionTypeDeposit) { // SOURCE
        *userId = [transaction objectForKey:kDWOResponseKeyTransactionSourceId];
        *name = [transaction objectForKey:kDWOResponseKeyTransactionSourceName];
    } else { // Destination
        *userId = [transaction objectForKey:kDWOResponseKeyTransactionDestinationId];
        *name = [transaction objectForKey:kDWOResponseKeyTransactionDestinationName];
    }
}

- (NSString *)imageUrlForUserId:(NSString *)userId userType:(NSString *)userType {
    if ([userType caseInsensitiveCompare:kDWOContactTypeDwolla] == NSOrderedSame) {
#warning move avatars url to another class
        return [NSString stringWithFormat:@"%@avatars/%@", self.baseUrl, userId];
    } else {
        return nil;
    }
}

- (DWOTransactionType)typeForTransaction:(NSDictionary *)transaction {
    NSString *rawType = [transaction objectForKey:kDWOResponseKeyTransactionType];
    
    if ([rawType isEqualToString:kDWOTransactionTypeMoneyReceived]) {
        return DWOTransactionTypeMoneyReceived;
    } else if ([rawType isEqualToString:kDWOTransactionTypeMoneySent]) {
        return DWOTransactionTypeMoneySent;
    } else if ([rawType isEqualToString:kDWOTransactionTypeDeposit]) {
        return DWOTransactionTypeDeposit;
    } else if ([rawType isEqualToString:kDWOTransactionTypeWithdrawal]) {
        return DWOTransactionTypeWithdrawal;
    } else if ([rawType isEqualToString:kDWOTransactionTypeFee]) {
        return DWOTransactionTypeFee;
    } else {
        return DWOTransactionTypeUnknown;
    }
}

- (NSNumber *)amountForTransaction:(NSDictionary *)transaction {
    return [self numberFromRaw:[transaction objectForKey:kDWOResponseKeyTransactionAmount]];
}

- (NSArray *)feesForTransaction:(NSDictionary *)transaction {
    NSMutableArray *fees = [NSMutableArray array];
    
    if ([[transaction objectForKey:kDWOResponseKeyTransactionFees] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *rawFee in [transaction objectForKey:kDWOResponseKeyTransactionFees]) {
            DWOTransactionFee *fee = [[DWOTransactionFee alloc] init];
            fee.feeId = [rawFee objectForKey:kDWOResponseKeyTransactionFeeId];
            fee.amount = [self numberFromRaw:[rawFee objectForKey:kDWOResponseKeyTransactionFeeAmount]];
            fee.type = [rawFee objectForKey:kDWOResponseKeyTransactionFeeType];
            [fees addObject:fee];
        }
    }
    
    return fees;
}

- (NSNumber *)numberFromRaw:(id)rawValue {
    if ([rawValue isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:rawValue];
    } else if ([rawValue isKindOfClass:[NSNumber class]]) {
        return rawValue;
    } else {
        return nil;
    }
}

@end
