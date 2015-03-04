//
//  DWONearbyContact+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWONearbyContact.h"
// lib
#import "DWOSendStrategy.h"

@interface DWONearbyContact (Dwolla)

- (DWOSendStrategy *)convertToSendStrategy;

@end
