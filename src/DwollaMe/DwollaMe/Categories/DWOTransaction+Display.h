//
//  Transaction+Display.h
//  DwollaMe
//
//  Created by Josh Aaseby on 1/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// models
#import "DWOTransaction.h"

@interface DWOTransaction (Display)

- (NSString *)displayStatus;
- (NSString *)displayType;

@end
