//
//  NSDate+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 1/7/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Dwolla)

- (NSString *)shortDate;
- (NSString *)longDateTime;
- (NSString *)ago;

@end
