//
//  NSObject+NSNull.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/18/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "NSObject+NSNull.h"

@implementation NSObject (NSNull)

- (id)normalizeNull {
    return ([self isKindOfClass:[NSNull class]]) ? nil : self;
}

@end
