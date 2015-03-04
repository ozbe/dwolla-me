//
//  DWOFundRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/4/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

@interface DWOFundRequest : NSObject

@property (nonatomic, strong) NSString *fundingSourceId;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, strong) NSNumber *amount;

@end
