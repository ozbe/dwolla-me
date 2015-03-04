//
//  NSString+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/4/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//


@interface NSString (Dwolla)

- (BOOL)isValidEmail;
- (BOOL)isValidPhone;
- (BOOL)isValidDwollaId;

@end
