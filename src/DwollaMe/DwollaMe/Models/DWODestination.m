//
//  DWODestination.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/12/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWODestination.h"

@implementation DWODestination

- (instancetype)initWithDestinationId:(NSString *)destinationId destinationType:(NSString *)destinationType {
    self = [super init];
    
    if (self) {
        self.destinationId = destinationId;
        self.destinationType = destinationType;
    }
    return self;
}

@end
