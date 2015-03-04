//
//  DWOPendingRequestsRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

@interface DWOMoneyRequestsRequest : NSObject

@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSNumber *skip;

@end
