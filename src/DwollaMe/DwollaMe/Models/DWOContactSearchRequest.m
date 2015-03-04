//
//  DWOContactSearchRequest.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/12/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWOContactSearchRequest.h"

@implementation DWOContactSearchRequest


- (DWOUserSearchFilterOptions *)options {
    if (!_options) {
        _options = [[DWOUserSearchFilterOptions alloc] init];
    }
    return _options;
}

@end
