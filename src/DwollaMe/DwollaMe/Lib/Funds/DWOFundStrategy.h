//
//  DWOFundStrategy.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// frameworks
#import <Foundation/Foundation.h>
// models
#import "DWOFundRequest.h"
#import "DWOFundingSource.h"
#import "DWOTransaction.h"

@protocol DWOFundStrategy <NSObject>

@property (nonatomic, readonly) NSString *submitTitle;

- (BOOL)isValidRequest:(DWOFundRequest *)request;
- (BOOL)isValidFundingSource:(DWOFundingSource *)fundingSource;
- (DWOTransaction *)submitRequest:(DWOFundRequest *)request error:(NSError **)error;

@end
