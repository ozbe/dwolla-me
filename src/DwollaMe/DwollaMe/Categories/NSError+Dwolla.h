//
//  NSError+Dwolla.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/1/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Dwolla)

- (NSString *)dwollaErrorMessage;
- (NSString *)dwollaErrorMessageWithDefaultMessage:(NSString *)defaultMessage;

@end
