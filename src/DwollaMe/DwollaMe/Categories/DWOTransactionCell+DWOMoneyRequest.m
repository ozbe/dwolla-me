//
//  DWOTransactionCell+DWOMoneyRequest.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/26/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransactionCell+DWOMoneyRequest.h"
// models
#import "DWOAccount.h"
// categories
#import "UIColor+Dwolla.h"
#import "NSNumber+Dwolla.h"
#import "NSDate+Dwolla.h"

@implementation DWOTransactionCell (DWOMoneyRequest)

- (void)setMoneyRequest:(DWOMoneyRequest *)moneyRequest accountId:(NSString *)accountId {
    DWOAccount *externalAccount = [self externalAccountForMoneyRequest:moneyRequest accountId:accountId];
    self.nameLabel.text = externalAccount.name;
    self.avatarImageView.imageUrl = externalAccount.imageUrl;
    self.amountLabel.text = [moneyRequest.amount displayAmount];
    self.amountLabel.textColor = (externalAccount == moneyRequest.source) ? [UIColor dwollaRedColor] : [UIColor dwollaGreenColor];
    self.dateLabel.text = [moneyRequest.requested ago];
    self.statusLabel.hidden = YES;
}

- (DWOAccount *)externalAccountForMoneyRequest:(DWOMoneyRequest *)moneyRequest accountId:(NSString *)accountId {
    return ([moneyRequest.source.accountId isEqualToString:accountId]) ? moneyRequest.destination : moneyRequest.source;
}

@end
