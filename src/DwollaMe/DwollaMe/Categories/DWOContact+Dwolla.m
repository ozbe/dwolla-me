//
//  DWOContact+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOContact+Dwolla.h"

@implementation DWOContact (Dwolla)

- (DWOSendStrategy *)convertToSendStrategy {
    DWOSendStrategy *sendStrategy = [[DWOSendStrategy alloc] init];
    sendStrategy.name = self.name;
    sendStrategy.destinationId = self.contactId;
    sendStrategy.destinationType = self.type;
    sendStrategy.imageUrl = self.imageUrl;
    return sendStrategy;
}

@end
