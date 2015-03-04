//
//  DWOUserSearchFilterOptions.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/15/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// header
#import "DWOUserSearchFilterOptions.h"
// models
#import "DWOUserSearchFilterOption.h"

@implementation DWOUserSearchFilterOptions

@synthesize idTypes = _idTypes;

- (NSArray *)idTypes {
    if (!_idTypes) {
        _idTypes = @[[[DWOUserSearchFilterOption alloc] initWithName:@"Dwolla"],
                     [[DWOUserSearchFilterOption alloc] initWithName:@"Email"],
                     [[DWOUserSearchFilterOption alloc] initWithName:@"Phone"],
                     [[DWOUserSearchFilterOption alloc] initWithName:@"Twitter"]
                     ];
    }
    
    return _idTypes;
}

- (void)reset {
    for (DWOUserSearchFilterOption *filterOption in self.idTypes) {
        [self resetFilterOption:filterOption];
    }
}

- (void)resetFilterOption:(DWOUserSearchFilterOption *)filterOption {
    filterOption.enabled = YES;
}

@end
