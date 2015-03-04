//
//  FundingSource.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOFundingSource.h"

@implementation DWOFundingSource

- (instancetype)initWithFundingSourceId:(NSString *)fundingSourceId
                                   name:(NSString *)name
                                   type:(NSString *)type
                               verified:(BOOL)verified
                         processingType:(NSString *)processingType {
    self = [super init];
    
    if (self) {
        _fundingSourceId = fundingSourceId;
        _name = name;
        _type = type;
        _verified = verified;
        _processingType = processingType;
    }
    
    return self;
}

@end
