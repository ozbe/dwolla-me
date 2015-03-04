//
//  FundingSourcesClient.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOFundingSourcesClient.h"
// models
#import "DWOFundingSource.h"
// data access
#import "DWOTransactionConverter.h"
// constants
#import "DWORestApiConstants.h"

@interface DWOFundingSourcesClient ()
@property (nonatomic, strong) DWOTransactionConverter *transactionConverter;
@end

@implementation DWOFundingSourcesClient

static NSString *DETAILS_BALANCE = @"Balance";

#pragma mark - Properties

- (DWOTransactionConverter *)transactionConverter {
    if (!_transactionConverter) {
        _transactionConverter = [[DWOTransactionConverter alloc] init];
    }
    return _transactionConverter;
}

#pragma mark - Public

- (NSArray *)fundingSourcesOrError:(NSError **)error {
    NSDictionary *parameters = @{
                                  kDWORequestKeyOAuthToken: self.credentials.token
                                };
    
    NSDictionary *rawFundingSources = [self getRelativePath:kDWORelativePathFundingSources withParameters:parameters error:error];
    
    return (*error) ? nil : [self convertToFundingSources:rawFundingSources];
}

- (NSArray *)fundingSourcesForDestination:(DWODestination *)destination error:(NSError **)error {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                             kDWORequestKeyOAuthToken: self.credentials.token,
                                             kDWORequestKeyFundingSourcesDestinationId : destination.destinationId
                                             }];
    
    if (destination.destinationType) {
        [parameters setObject:destination.destinationType forKey:kDWORequestKeyFundingSourcesDestinationType];
    }
    
    NSDictionary *rawFundingSources = [self getRelativePath:kDWORelativePathFundingSources withParameters:parameters error:error];
    
    return (*error) ? nil : [self convertToFundingSources:rawFundingSources];
}

- (NSNumber *)balanceForFundingSourceId:(NSString *)fundingSourceId error:(NSError **)error {
    NSString *relativePath = [NSString stringWithFormat:@"%@/%@", kDWORelativePathFundingSources, fundingSourceId];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      kDWORequestKeyOAuthToken: self.credentials.token
                                                                                      }];
    
    NSDictionary *rawDetails = [self getRelativePath:relativePath withParameters:parameters error:error];
    
    id balance = [[rawDetails objectForKey:kDWOResponseKeyResponse] objectForKey:DETAILS_BALANCE];
    
    return ([balance isKindOfClass:[NSNumber class]]) ? balance : nil;
}

- (DWOTransaction *)deposit:(DWOFundRequest *)request error:(NSError **)error {
    return [self processFundRequest:request subpath:kDWOSubpathFundingSourcesDeposit error:error];
}

- (DWOTransaction *)withdraw:(DWOFundRequest *)request error:(NSError **)error {
    return [self processFundRequest:request subpath:kDWOSubpathFundingSourcesWithdraw error:error];
}

#pragma mark - Private

- (DWOTransaction *)processFundRequest:(DWOFundRequest *)request subpath:(NSString *)subpath error:(NSError **)error {
    NSString *relativePath = [self fundRelativePathWithSubpath:subpath fundingSourceId:request.fundingSourceId];
    NSDictionary *body = @{
                           kDWORequestKeyOAuthToken: self.credentials.token,
                           kDWORequestKeyFundAmount: [request.amount stringValue],
                           kDWORequestKeyFundPin: request.pin
                           };
    
    NSDictionary *rawTransaction = [self postRelativePath:relativePath withBody:body error:error];
    
    return (*error) ? nil : [self convertToTransactionFromDictionary:[rawTransaction objectForKey:kDWOResponseKeyResponse]];
}

- (NSString *)fundRelativePathWithSubpath:(NSString *)subpath fundingSourceId:(NSString *)fundingSourceId {
    return [NSString stringWithFormat:@"%@/%@/%@", kDWORelativePathFundingSources, fundingSourceId, subpath];
}

- (DWOTransaction *)convertToTransactionFromDictionary:(NSDictionary *)rawTransaction {
    return [self.transactionConverter convertFromDictionary:rawTransaction];
}

- (NSArray *)convertToFundingSources:(NSDictionary *)rawFundingSources {
    NSMutableArray *fundingSources = [NSMutableArray array];
    
    for (NSDictionary *rawFundingSource in [rawFundingSources objectForKey:kDWOResponseKeyResponse]) {
        [fundingSources addObject:[self convertToFundingSourceFromDictionary:rawFundingSource]];
    }
    
    return fundingSources;
}

- (DWOFundingSource *)convertToFundingSourceFromDictionary:(NSDictionary *)dictionary {
    NSString *fundingSourceId = [dictionary objectForKey:kDWOResponseKeyFundingSourceId];
    
    return [[DWOFundingSource alloc] initWithFundingSourceId:fundingSourceId name:[self nameForFundingSource:dictionary withFundingSourceId:fundingSourceId] type:[dictionary objectForKey:kDWOResponseKeyFundingSourceType] verified:[self isVerifiedFundingSource:dictionary] processingType:[dictionary objectForKey:kDWOResponseKeyFundingSourceProcessingType]];
}

- (NSString *)nameForFundingSource:(NSDictionary *)rawFundingSource withFundingSourceId:(NSString *)fundingSourceId {
    static NSString *VeridianPrefix = @"Veridian Credit Union";
    
    if ([fundingSourceId isEqualToString:@"Balance"]) {
        return @"Cash";
    } else {
        NSString *name = [rawFundingSource objectForKey:kDWOResponseKeyFundingSourceName];

        if ([fundingSourceId isEqualToString:@"Credit"]) {
            return name;
        } else {
            NSRange range = [name rangeOfString:VeridianPrefix];
            
            if (range.location != NSNotFound) {
                return [name stringByReplacingOccurrencesOfString:VeridianPrefix withString:@"Veridian"];
            } else {
                range = [name rangeOfString:@" - " options:NSBackwardsSearch];
                
                if (range.location == NSNotFound) {
                    return name;
                } else {
                    return [name substringWithRange:NSMakeRange(0, range.location)];
                }
            }
        }
    }
}

- (BOOL)isVerifiedFundingSource:(NSDictionary *)rawFundingSource {
    NSNumber *verified = [rawFundingSource objectForKey:kDWOResponseKeyFundingSourceVerified];
    return [verified intValue] > 0;
}

@end
