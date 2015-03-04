//
//  DWOBoolSearchOption.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOBoolSearchOption.h"

@implementation DWOBoolSearchOption

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name {
    return [self initWithIdentifier:identifier name:name enabled:NO];
}

- (instancetype)initWithIdentifier:(NSString *)identifier name:(NSString *)name enabled:(BOOL)enabled {
    self = [super init];
    
    if (self) {
        _identifier = identifier;
        _name = name;
        self.enabled = enabled;
    }
    
    return self;
}

@end
