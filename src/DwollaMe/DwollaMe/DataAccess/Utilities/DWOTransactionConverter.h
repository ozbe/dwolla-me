//
//  DWOTransactionConverter.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// models
#import "DWOTransaction.h"

@interface DWOTransactionConverter : NSObject

@property (nonatomic, strong) NSString *baseUrl;

- (DWOTransaction *)convertFromDictionary:(NSDictionary *)dictionary;

@end
