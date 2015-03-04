//
//  DWOFulfillMoneyRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/18/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

@interface DWOFulfillMoneyRequest : NSObject

@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic) BOOL acceptFee;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, strong) NSString *fundsSource;

@end
