//
//  DWOSendStrategy.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// lib
#import "DWOTransferStrategy.h"
// models
#import "DWOSendRequest.h"

@interface DWOSendStrategy : NSObject <DWOTransferStrategy>

@property (nonatomic, strong) DWOSendRequest *sendRequest;

@end
