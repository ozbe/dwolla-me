//
//  FundingSource.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

@interface DWOFundingSource : NSObject

@property (nonatomic, strong) NSString *fundingSourceId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign, getter = isVerified) BOOL verified;
@property (nonatomic, strong) NSString *processingType;

- (instancetype)initWithFundingSourceId:(NSString *)fundingSourceId
                                   name:(NSString *)name
                                   type:(NSString *)type
                               verified:(BOOL)verified
                         processingType:(NSString *)processingType;

@end
