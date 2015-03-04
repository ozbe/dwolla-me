//
//  DWOTransactionFee.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/27/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOTransactionFee.h"

@implementation DWOTransactionFee

- (instancetype)initWithFeeId:(NSString *)feeId amount:(NSNumber *)amount type:(NSString *)type {
    self = [super init];
    
    if (self) {
        _feeId = feeId;
        _amount = amount;
        _type = type;
    }
    
    return self;
}

@end
