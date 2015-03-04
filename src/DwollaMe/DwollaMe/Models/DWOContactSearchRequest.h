//
//  DWOContactSearchRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/12/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWOUserSearchFilterOptions.h"

@interface DWOContactSearchRequest : NSObject

@property (nonatomic, strong) NSString *term;
@property (nonatomic, strong) DWOUserSearchFilterOptions *options;
@property (nonatomic, strong) NSNumber *limit;

@end
