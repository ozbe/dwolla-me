//
//  DWOTransaction+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/18/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWOTransaction.h"
// lib
#import "DWOSendStrategy.h"

@interface DWOTransaction (Dwolla)

- (BOOL)isTransfer;
- (BOOL)isFunding;
- (DWOSendStrategy *)convertToSendStrategy;

@end
