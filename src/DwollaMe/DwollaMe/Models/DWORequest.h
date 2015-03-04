//
//  DWORequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/23/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

@interface DWORequest : NSObject

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *sourceId;
@property (nonatomic, strong) NSString *sourceType;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, assign) BOOL senderAssumesCosts;

@end
