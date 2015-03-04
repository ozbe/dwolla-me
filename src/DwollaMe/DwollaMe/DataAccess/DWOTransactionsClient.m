//
//  DWOTransactionsClient.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOTransactionsClient.h"
// models
#import "DWOTransaction.h"
#import "DWOTransactionFee.h"
#import "DWOBoolSearchOption.h"
// data access
#import "DWOTransactionConverter.h"
// constants
#import "DWORestApiConstants.h"

@interface DWOTransactionsClient ()
@property (nonatomic, strong) DWOTransactionConverter *transactionConverter;
@end

@implementation DWOTransactionsClient

#pragma mark - Properties

- (DWOTransactionConverter *)transactionConverter {
    if (!_transactionConverter) {
        _transactionConverter = [[DWOTransactionConverter alloc] init];
    }
    return _transactionConverter;
}

#pragma mark - Public

- (NSArray *)transactions:(DWOTransactionsRequest *)request error:(NSError **)error {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      kDWORequestKeyOAuthToken: self.credentials.token,
                                                                                      kDWORequestKeyTransactionsTypes: [self convertToTypesValue:request.types]
                                                                                      }];
    
    if (request.limit && [request.limit intValue]) {
        [parameters setObject:[request.limit stringValue] forKey:kDWORequestKeyLimit];
    }
    
    if (request.skip && [request.skip intValue]) {
        [parameters setObject:[request.skip stringValue] forKey:kDWORequestKeySkip];
    }
    
    if (request.startDate) {
       [parameters setObject:request.startDate forKey:kDWORequestKeyTransactionsSinceDate];
    }
    if (request.endDate) {
        [parameters setObject:request.endDate forKey:kDWORequestKeyTransactionsEndDate];
    }
    
    NSDictionary *rawTransactions = [self getRelativePath:kDWORelativePathTransactions withParameters:parameters error:error];
    
    return (*error) ? nil : [self convertToTransactions:rawTransactions];
}

- (DWOSendResponse *)send:(DWOSendRequest *)request error:(NSError **)error {
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      kDWORequestKeyOAuthToken: self.credentials.token,
                                                                                      kDWORequestKeyTransactionSendAmount: [request.amount stringValue],
                                                                                      kDWORequestKeyTransactionSendAssumeCosts: [NSNumber numberWithBool:request.acceptFee],
                                                                                      kDWORequestKeyTransactionSendDestinationId: request.destinationId,
                                                                                      kDWORequestKeyTransactionSendPin: request.pin
                                                                                      }];
    
    if (request.destinationType) {
        [body setObject:request.destinationType forKey:kDWORequestKeyTransactionSendDestinationType];
    }
    
    if (request.fundsSource) {
        [body setObject:request.fundsSource forKey:kDWORequestKeyTransactionSendFundsSource];
    }
    
    if (request.notes) {
        [body setObject:request.notes forKey:kDWORequestKeyTransactionSendNotes];
    }
    
    NSDictionary *rawResponse = [self postRelativePath:kDWORelativePathTransactionSend withBody:body error:error];
    
    return (*error) ? nil : [self convertToResponse:rawResponse];
}

- (DWOSendResponse *)convertToResponse:(NSDictionary *)rawResponse {
    DWOSendResponse *response = [[DWOSendResponse alloc] init];
    response.transactionId = [rawResponse objectForKey:kDWOResponseKeyResponse];
    response.date = [NSDate date];
    return response;
}

- (NSString *)getMessageForSendResponse:(NSDictionary *)sendResponse {
    NSString *message = [sendResponse objectForKey:kDWOResponseKeyMessage];
    NSRange range = [message rangeOfString:@"\r\n"];
    return (range.location == NSNotFound) ? message : [message substringToIndex:range.location];
}

- (NSArray *)convertToTransactions:(NSDictionary *)rawTransactions {
    NSMutableArray *transactions = [NSMutableArray array];
    for (NSDictionary *rawTransaction in [rawTransactions objectForKey:kDWOResponseKeyResponse]) {
        [transactions addObject:[self.transactionConverter convertFromDictionary:rawTransaction]];
    }
    
    return transactions;
}

- (NSString *)convertToTypesValue:(NSArray *)types {
    NSMutableString *value = [NSMutableString string];
    
    for (DWOBoolSearchOption *option in types) {
        if (!option.enabled) {
            continue;
        }
        
        if (value.length) {
            [value appendString:@","];
        }
        [value appendString:option.identifier];
    }
    
    return value;
}

@end
