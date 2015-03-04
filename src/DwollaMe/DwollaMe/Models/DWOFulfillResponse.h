//
//  DWOFulfillResponse.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/18/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWOTransaction.h"

@interface DWOFulfillResponse : NSObject

@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSString *transactionId;
@property (nonatomic, assign) DWOTransactionStatus status;

@end
