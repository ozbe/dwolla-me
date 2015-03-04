//
//  DWOMoneyRequest.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/30/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// header
#import "DWOMoneyRequest.h"

@implementation DWOMoneyRequest

#pragma mark - Properties

- (DWOAccount *)destination {
    if (!_destination) {
        _destination = [[DWOAccount alloc] init];
    }
    return _destination;
}

- (DWOAccount *)source {
    if (!_source) {
        _source = [[DWOAccount alloc] init];
    }
    return _source;
}

- (NSArray *)additionalFees {
    if (!_additionalFees) {
        _additionalFees = [NSArray array];
    }
    return _additionalFees;
}

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.status = DWOMoneyRequestStatusUnknown;
    }
    
    return self;
}

@end
