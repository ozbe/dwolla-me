//
//  DWOContact+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWOContact.h"
// lib
#import "DWOSendStrategy.h"

@interface DWOContact (Dwolla)

- (DWOSendStrategy *)convertToSendStrategy;

@end
