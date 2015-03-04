//
//  NSString+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/4/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "NSString+Dwolla.h"

@implementation NSString (Dwolla)

static NSString *emailRegEx =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

static NSString *phoneRegEx = @"^(\\([0-9]{3}\\) ?|[0-9]{3}-)[0-9]{3}-[0-9]{4}$|^(\\([0-9]{3}\\) |[0-9]{3})[0-9]{3}[0-9]{4}$";

static NSString *dwollaIdRegEx = @"^(812-?\\d\\d\\d-?\\d\\d\\d\\d)$";

- (BOOL)isValidEmail {
    return [self matchesRegex:emailRegEx];
}

- (BOOL)isValidPhone {
    return [self matchesRegex:phoneRegEx];
}

- (BOOL)isValidDwollaId {
    return [self matchesRegex:dwollaIdRegEx];
}

- (BOOL)matchesRegex:(NSString *)regExPattern {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExPattern];
    return [predicate evaluateWithObject:self];
}

@end
