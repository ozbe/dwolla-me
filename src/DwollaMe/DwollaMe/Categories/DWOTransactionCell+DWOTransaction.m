//
//  DWOTransactionCell+DWOTransaction.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/26/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransactionCell+DWOTransaction.h"
// categories
#import "DWOTransaction+Display.h"
#import "NSDate+Dwolla.h"
#import "UIColor+Dwolla.h"
#import "NSNumber+Dwolla.h"

@implementation DWOTransactionCell (DWOTransaction)

- (void)setTransaction:(DWOTransaction *)transaction {
    self.nameLabel.text = transaction.name;
    self.amountLabel.text = [self prettyAmount:transaction];
    self.amountLabel.textColor = [self amountColor:transaction];
    [self setAvatar:transaction];
    self.statusLabel.text = (transaction.status == DWOTransactionStatusProcessed) ? nil : [transaction displayStatus];
    self.dateLabel.text = [transaction.date ago];
    
    self.statusLabel.layer.cornerRadius = 3;
    self.statusLabel.hidden = !self.statusLabel.text.length;
}

#pragma mark - Private

- (NSString *)prettyAmount:(DWOTransaction *)transaction {
    return [NSString stringWithFormat:@"%@%@", [self amountPrefix:transaction.type], [transaction.amount displayAmount]];
}

- (NSString *)amountPrefix:(DWOTransactionType)type {
    return [self isTransactionIncoming:type] ? @"+" : @"-";
}

#warning move to category
- (BOOL)isTransactionIncoming:(DWOTransactionType)type {
    return type == DWOTransactionTypeDeposit || type == DWOTransactionTypeMoneyReceived;
}

- (UIColor *)amountColor:(DWOTransaction *)transaction {
#warning what about fees?
    if ([self isTransactionIncoming:transaction.type]) {
        return [UIColor colorWithRed:0 green:153.0/255 blue:0 alpha:1];
    } else {
        return [UIColor colorWithRed:192.0/255 green:80.0/255 blue:77.0/255 alpha:1];
    }
}

- (void)setAvatar:(DWOTransaction *)transaction {
    if (transaction.type == DWOTransactionTypeDeposit) {
        self.avatarImageView.image = [UIImage imageNamed:@"Deposit"];
    } else if (transaction.type == DWOTransactionTypeWithdrawal) {
        self.avatarImageView.image = [UIImage imageNamed:@"Withdraw"];
    } else if (transaction.type == DWOTransactionTypeFee && [transaction.name isEqualToString:@"Dwolla"]) {
        self.avatarImageView.image = [UIImage imageNamed:@"Dwolla Logo"];
    } else {
        self.avatarImageView.imageUrl = transaction.imageUrl;
    }
}


@end
