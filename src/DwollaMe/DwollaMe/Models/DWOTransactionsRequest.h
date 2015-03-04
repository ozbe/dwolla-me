//
//  DWOTransactionsRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/1/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

@interface DWOTransactionsRequest : NSObject

@property (nonatomic, strong) NSNumber *skip;
@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *types;

@end
