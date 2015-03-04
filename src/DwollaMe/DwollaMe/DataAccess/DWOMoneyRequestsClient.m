//
//  DWORequestsClient.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOMoneyRequestsClient.h"
// models
#import "DWOMoneyRequest.h"
// constants
#import "DWORestApiConstants.h"
// categories
#import "NSString+DWOTransaction.h"
#import "NSObject+NSNull.h"
// data access
#import "DWODateFormatter.h"

@implementation DWOMoneyRequestsClient

#pragma mark - Static

static DWODateFormatter *_dateFormatter;

+ (DWODateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[DWODateFormatter alloc] init];
    }
    return _dateFormatter;
}

#pragma mark - Public

- (NSArray *)moneyRequests:(DWOMoneyRequestsRequest *)request error:(NSError **)error {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      kDWORequestKeyOAuthToken: self.credentials.token
                                                                                      }];
    
    if (request.skip && [request.skip intValue]) {
        [parameters setObject:[NSString stringWithFormat:@"%i", [request.skip intValue]] forKey:kDWORequestKeySkip];
    }
    
    if (request.limit && [request.limit intValue]) {
        [parameters setObject:[NSString stringWithFormat:@"%i", [request.limit intValue]] forKey:kDWORequestKeyLimit];
    }
    
    NSDictionary *response = [self getRelativePath:kDWORelativePathRequests withParameters:parameters error:error];
    
    return (*error) ? nil : [self convertToMoneyRequests:response];
}

- (void)cancelRequest:(NSString *)requestId error:(NSError **)error {
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      kDWORequestKeyOAuthToken: self.credentials.token
                                                                                      }];
    NSString *relativePath = [self requestRelativePathWithSubpath:kDWOSubpathRequestCancel requestId:requestId];
    [self postRelativePath:relativePath withBody:body error:error];
}

- (DWOFulfillResponse *)fulfillRequest:(DWOFulfillMoneyRequest *)request error:(NSError **)error {
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                            kDWORequestKeyOAuthToken: self.credentials.token,
                                                                            kDWORequestKeyFullfillRequestAmount: [request.amount stringValue],
                                                                            kDWORequestKeyFullfillRequestPin: request.pin,
                                                                            kDWORequestKeyFullfillRequestAssumeCosts: [NSNumber numberWithBool:request.acceptFee]
                                                                                }];

    if (request.fundsSource) {
        [body setObject:request.fundsSource forKey:kDWORequestKeyFullfillRequestFundsSource];
    }
    
    if (request.notes) {
        [body setObject:request.notes forKey:kDWORequestKeyFullfillRequestNotes];
    }
    
    NSString *relativePath = [self requestRelativePathWithSubpath:kDWOSubpathRequestFulfill requestId:request.requestId];
    NSDictionary *response = [self postRelativePath:relativePath withBody:body error:error];
    
    return (*error) ? nil: [self convertToFulfillResponse:response];
}

- (DWORequestResponse *)request:(DWORequest *)request error:(NSError **)error {
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                kDWORequestKeyOAuthToken: self.credentials.token,
                                                                                kDWORequestKeyMoneyRequestAmount: [request.amount stringValue],
                                                                                kDWORequestKeyMoneyRequestSenderAssumeCosts: [NSNumber numberWithBool:request.senderAssumesCosts],
                                                                                kDWORequestKeyMoneyRequestSourceId: request.sourceId,
                                                                                kDWORequestKeyMoneyRequestSourceType: request.sourceType
                                                                                }];
    
    if (request.notes) {
        [body setObject:request.notes forKey:kDWORequestKeyFullfillRequestNotes];
    }

    NSDictionary *response = [self postRelativePath:kDWORelativePathRequests withBody:body error:error];
    
    return (*error) ? nil : [self convertToRequestResponse:response];
}

#pragma mark - Private

- (DWORequestResponse *)convertToRequestResponse:(NSDictionary *)rawRequestResponse {
    DWORequestResponse *requestResponse = [[DWORequestResponse alloc] init];
    requestResponse.requestId = [rawRequestResponse objectForKey:kDWOResponseKeyResponse];
    return requestResponse;
}

- (NSString *)requestRelativePathWithSubpath:(NSString *)subpath requestId:(NSString *)requestId {
    return [NSString stringWithFormat:@"%@/%@/%@", kDWORelativePathRequests, requestId, subpath];
}

- (DWOFulfillResponse *)convertToFulfillResponse:(NSDictionary *)rawFullfillResponse {
    
    DWOFulfillResponse *response = [[DWOFulfillResponse alloc] init];
    response.transactionId = [rawFullfillResponse objectForKey:kDWOResponseKeyFulfillRequestTransactionId];
    response.requestId = [rawFullfillResponse objectForKey:kDWOResponseKeyFulfillRequestId];
    response.status = [[rawFullfillResponse objectForKey:kDWOResponseKeyFulfillRequestTransactionStatus] convertToTransactionStatus];
    return response;
}

- (NSArray *)convertToMoneyRequests:(NSDictionary *)rawPendingRequests {
    NSMutableArray *requests = [NSMutableArray array];
    
    for (NSDictionary *rawRequest in [rawPendingRequests objectForKey:kDWOResponseKeyResponse]) {
        NSDictionary *rawDestination = [rawRequest objectForKey:kDWOResponseKeyMoneyRequestDestination];
        NSDictionary *rawSource = [rawRequest objectForKey:kDWOResponseKeyMoneyRequestSource];
        
        DWOMoneyRequest *request = [[DWOMoneyRequest alloc] init];
        request.requestId = [rawRequest objectForKey:kDWOResponseKeyMoneyRequestId];
        request.amount = [rawRequest objectForKey:kDWOResponseKeyMoneyRequestAmount];
        request.destination.accountId = [rawDestination objectForKey:kDWOResponseKeyMoneyRequestDestinationId];
        request.destination.type = [rawDestination objectForKey:kDWOResponseKeyMoneyRequestDestinationType];
        request.destination.name = [rawDestination objectForKey:kDWOResponseKeyMoneyRequestDestinationName];
        request.destination.imageUrl = [self imageUrlForAccount:request.destination dictionary:rawDestination];
        
        request.source.accountId = [rawSource objectForKey:kDWOResponseKeyMoneyRequestSourceId];
        request.source.type = [rawSource objectForKey:kDWOResponseKeyMoneyRequestSourceType];
        request.source.name = [rawSource objectForKey:kDWOResponseKeyMoneyRequestSourceName];
        request.source.imageUrl = [self imageUrlForAccount:request.source dictionary:rawSource];
        request.requested = [[DWOMoneyRequestsClient dateFormatter] dateFromLongString:[rawRequest objectForKey:kDWOResponseKeyMoneyRequestDateRequested]];
        request.notes = [rawRequest objectForKey:kDWOResponseKeyMoneyRequestNotes];
#warning need to get everything else
        [requests addObject:request];
    }
    
    return requests;
}

#warning move avatars url to another class
- (NSString *)imageUrlForAccount:(DWOAccount *)account dictionary:(NSDictionary *)dictionary {
    NSString *imageUrl = [[dictionary objectForKey:kDWOResponseKeyMoneyRequestDestinationImage] normalizeNull];
    
    if (!imageUrl && [account.type caseInsensitiveCompare:kDWOContactTypeDwolla] == NSOrderedSame) {
        return [NSString stringWithFormat:@"%@avatars/%@", self.credentials.baseUrl, account.accountId];
    }
    
    return imageUrl;
}

@end
