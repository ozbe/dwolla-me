//
//  DWOTransactionFee.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/27/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

@interface DWOTransactionFee : NSObject

@property (nonatomic, strong) NSString *feeId;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *type;

@end
