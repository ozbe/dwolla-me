//
//  DWOTransferStrategy.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/31/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

@protocol DWOTransferStrategy <NSObject>

@property (nonatomic, strong) NSString *destinationId;
@property (nonatomic, strong) NSString *destinationType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, assign) BOOL acceptFee;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, strong) NSString *fundsSource;
@property (nonatomic, readonly) BOOL isValid;

- (NSError *)process;

@end
