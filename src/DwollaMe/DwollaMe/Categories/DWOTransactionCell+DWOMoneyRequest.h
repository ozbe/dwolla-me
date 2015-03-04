//
//  DWOTransactionCell+DWOMoneyRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/26/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransactionCell.h"
// models
#import "DWOMoneyRequest.h"

@interface DWOTransactionCell (DWOMoneyRequest)

- (void)setMoneyRequest:(DWOMoneyRequest *)moneyRequest accountId:(NSString *)accountId;

@end
