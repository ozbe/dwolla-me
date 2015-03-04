//
//  DWOSendRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

@interface DWOSendRequest : NSObject

@property (nonatomic, strong) NSString *destinationId;
@property (nonatomic, strong) NSString *destinationType;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, assign) BOOL acceptFee;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, strong) NSString *fundsSource;
@property (nonatomic, readonly) BOOL isValid;

@end
