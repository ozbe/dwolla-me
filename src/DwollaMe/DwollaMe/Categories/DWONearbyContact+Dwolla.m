//
//  DWONearbyContact+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWONearbyContact+Dwolla.h"

@implementation DWONearbyContact (Dwolla)

- (DWOSendStrategy *)convertToSendStrategy {
    DWOSendStrategy *sendStrategy = [[DWOSendStrategy alloc] init];
    sendStrategy.sendRequest.destinationId = self.dwollaId;
    sendStrategy.sendRequest.destinationType = self.type;
    sendStrategy.name = self.name;
    sendStrategy.imageUrl = self.imageUrl;
    return sendStrategy;
}

@end
