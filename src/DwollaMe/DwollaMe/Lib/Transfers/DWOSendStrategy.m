//
//  DWOSendStrategy.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOSendStrategy.h"
// data access
#import "DWOTransactionsClient.h"

@interface DWOSendStrategy ()
@property (nonatomic, strong) DWOTransactionsClient *transactionsClient;
@end

@implementation DWOSendStrategy

#pragma mark - Properties

- (DWOTransactionsClient *)transactionsClient {
    if (!_transactionsClient) {
        _transactionsClient = [[DWOTransactionsClient alloc] init];
    }
    return _transactionsClient;
}

- (DWOSendRequest *)sendRequest {
    if (!_sendRequest) {
        _sendRequest = [[DWOSendRequest alloc] init];
    }
    return _sendRequest;
}

#pragma mark - DWOTransferStategy

@synthesize name, imageUrl;

- (NSString *)destinationId {
    return self.sendRequest.destinationId;
}

- (void)setDestinationId:(NSString *)destinationId {
    self.sendRequest.destinationId = destinationId;
}

- (NSString *)destinationType {
    return self.sendRequest.destinationType;
}

- (void)setDestinationType:(NSString *)destinationType {
    self.sendRequest.destinationType = destinationType;
}

- (NSNumber *)amount {
    return self.sendRequest.amount;
}

- (void)setAmount:(NSNumber *)amount {
    self.sendRequest.amount = amount;
}

- (BOOL)acceptFee {
    return self.sendRequest.acceptFee;
}

- (void)setAcceptFee:(BOOL)acceptFee {
    self.sendRequest.acceptFee = acceptFee;
}

- (NSString *)notes {
    return self.sendRequest.notes;
}

- (void)setNotes:(NSString *)notes {
    self.sendRequest.notes = notes;
}

- (NSString *)pin {
    return self.sendRequest.pin;
}

- (void)setPin:(NSString *)pin {
    self.sendRequest.pin = pin;
}

- (NSString *)fundsSource {
    return self.sendRequest.fundsSource;
}

- (void)setFundsSource:(NSString *)fundsSource {
    self.sendRequest.fundsSource = fundsSource;
}

- (BOOL)isValid {
    return self.sendRequest.isValid;
}

- (NSError *)process {
    
    NSError *error;
    [self.transactionsClient send:self.sendRequest error:&error];
    
    return nil;
}

@end
