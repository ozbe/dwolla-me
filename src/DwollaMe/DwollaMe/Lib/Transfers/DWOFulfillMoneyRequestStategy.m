//
//  DWOFulfillMoneyRequestStategy.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOFulfillMoneyRequestStategy.h"
// data access
#import "DWOMoneyRequestsClient.h"

@interface DWOFulfillMoneyRequestStategy ()
@property (nonatomic, strong) DWOMoneyRequestsClient *moneyRequestsClient;
@end

@implementation DWOFulfillMoneyRequestStategy

#pragma mark - Properties

- (DWOMoneyRequestsClient *)moneyRequestsClient {
    if (!_moneyRequestsClient) {
        _moneyRequestsClient = [[DWOMoneyRequestsClient alloc] init];
    }
    return _moneyRequestsClient;
}

- (DWOFulfillMoneyRequest *)fulfillMoneyRequest {
    if (!_fulfillMoneyRequest) {
        _fulfillMoneyRequest = [[DWOFulfillMoneyRequest alloc] init];
    }
    return _fulfillMoneyRequest;
}

#pragma mark - DWOTransferStrategy

@synthesize name, imageUrl, destinationId, destinationType;

- (NSNumber *)amount {
    return self.fulfillMoneyRequest.amount;
}

- (void)setAmount:(NSNumber *)amount {
    self.fulfillMoneyRequest.amount = amount;
}

- (BOOL)acceptFee {
    return self.fulfillMoneyRequest.acceptFee;
}

- (void)setAcceptFee:(BOOL)acceptFee {
    self.fulfillMoneyRequest.acceptFee = acceptFee;
}

- (NSString *)notes {
    return self.fulfillMoneyRequest.notes;
}

- (void)setNotes:(NSString *)notes {
    self.fulfillMoneyRequest.notes = notes;
}

- (NSString *)pin {
    return self.fulfillMoneyRequest.pin;
}

- (void)setPin:(NSString *)pin {
    self.fulfillMoneyRequest.pin = pin;
}

- (NSString *)fundsSource {
    return self.fulfillMoneyRequest.fundsSource;
}

- (void)setFundsSource:(NSString *)fundsSource {
    self.fulfillMoneyRequest.fundsSource = fundsSource;
}

- (BOOL)isValid {
    return NO;
}

- (NSError *)process {
    NSError *error;
    [self.moneyRequestsClient fulfillRequest:self.fulfillMoneyRequest error:&error];
    return error;
}

@end
