//
//  DWOUserSearchFilterOption.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/15/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// header
#import "DWOUserSearchFilterOption.h"

@implementation DWOUserSearchFilterOption

- (instancetype)initWithName:(NSString *)name {
    return [self initWithName:name enabled:YES];
}

- (instancetype)initWithName:(NSString *)name enabled:(BOOL)enabled {
    self = [super init];
    
    if (self) {
        _name = name;
        self.enabled = enabled;
    }
    
    return self;
}

@end
