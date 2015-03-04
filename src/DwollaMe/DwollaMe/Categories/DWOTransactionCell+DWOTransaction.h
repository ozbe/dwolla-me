//
//  DWOTransactionCell+DWOTransaction.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/26/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// views
#import "DWOTransactionCell.h"
// models
#import "DWOTransaction.h"

@interface DWOTransactionCell (DWOTransaction)

- (void)setTransaction:(DWOTransaction *)transaction;

@end
