//
//  DWOTransaction+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/18/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransaction+Dwolla.h"

@implementation DWOTransaction (Dwolla)

- (BOOL)isTransfer {
    return self.type == DWOTransactionTypeMoneyReceived || self.type == DWOTransactionTypeMoneySent;
}

- (BOOL)isFunding {
    return self.type == DWOTransactionTypeDeposit || self.type == DWOTransactionTypeWithdrawal;
}

- (DWOSendStrategy *)convertToSendStrategy {
    DWOSendRequest *sendRequest = [[DWOSendRequest alloc] init];
    sendRequest.destinationId = self.userId;
    
    DWOSendStrategy *sendStrategy = [[DWOSendStrategy alloc] init];
    sendStrategy.sendRequest = sendRequest;
    sendStrategy.imageUrl = self.imageUrl;
    sendStrategy.name = self.name;
    return sendStrategy;
}

@end
