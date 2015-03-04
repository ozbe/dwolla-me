//
//  NSNumber+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 1/7/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "NSNumber+Dwolla.h"

@implementation NSNumber (Dwolla)

- (NSString *)displayAmount {
    return [NSString stringWithFormat:@"$%.02f", [self doubleValue]];
}

@end
