//
//  DWOErrorConstants.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOErrorConstants.h"

// domains
NSString * const kDWOErrorDomain = @"me.aaseby.DwollaMe";

// error codes
NSInteger const kDWOErrorCodeApi = 1;
NSInteger const kDWOErrorCodeClient = 2;

// user info keys
NSString * const kDWOErrorUserInfoKeyMessage = @"DWOMessage";
NSString * const kDWOErrorUserInfoKeyExceptionName = @"DWOExceptionName";
NSString * const kDWOErrorUserInfoKeyExceptionReason = @"DWOExceptionReason";
NSString * const kDWOErrorUserInfoKeyExceptionCallStackReturnAddresses = @"DWOExceptionCallStackReturnAddresses";
NSString * const kDWOErrorUserInfoKeyExceptionCallStackSymbols = @"DWOExceptionCallStackSymbols";
NSString * const kDWOErrorUserInfoKeyExceptionUserInfo = @"DWOExceptionUserInfo";