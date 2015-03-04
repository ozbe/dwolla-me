//
//  NSError+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/1/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "NSError+Dwolla.h"
// constants
#import "DWOErrorConstants.h"

@implementation NSError (Dwolla)

- (NSString *)dwollaErrorMessage {
    return [self.domain isEqualToString:kDWOErrorDomain] ? [self.userInfo objectForKey:kDWOErrorUserInfoKeyMessage] : nil;
}

- (NSString *)dwollaErrorMessageWithDefaultMessage:(NSString *)defaultMessage {
    NSString *message = [self dwollaErrorMessage];
    return (message) ? message : defaultMessage;
}

@end
