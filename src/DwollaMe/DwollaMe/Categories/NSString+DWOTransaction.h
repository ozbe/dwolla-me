//
//  NSString+DWOTransaction.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/23/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWOTransaction.h"

@interface NSString (DWOTransaction)

- (DWOTransactionStatus)convertToTransactionStatus;

@end
