//
//  DWOSendRequest.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOSendRequest.h"

@implementation DWOSendRequest

- (NSString *)pin {
    if (!_pin) {
        _pin = [NSString string];
    }
    return _pin;
}

- (NSNumber *)amount {
    if (!_amount) {
        _amount = [NSNumber numberWithDouble:0];
    }
    return _amount;
}

- (BOOL)isValid {
    return self.destinationId &&
        [self.amount doubleValue] > 0 &&
        self.pin.length == 4;
}

@end
