//
//  DWOFulfillMoneyRequestStategy.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// lib
#import "DWOTransferStrategy.h"
// models
#import "DWOFulfillMoneyRequest.h"

@interface DWOFulfillMoneyRequestStategy : NSObject <DWOTransferStrategy>

@property (nonatomic, strong) DWOFulfillMoneyRequest *fulfillMoneyRequest;

@end
