//
//  DWOErrorConstants.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/5/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// domains
extern NSString * const kDWOErrorDomain;

// error codes
extern NSInteger const kDWOErrorCodeApi;
extern NSInteger const kDWOErrorCodeClient;

// user info keys
extern NSString * const kDWOErrorUserInfoKeyMessage;
extern NSString * const kDWOErrorUserInfoKeyExceptionName;
extern NSString * const kDWOErrorUserInfoKeyExceptionReason;
extern NSString * const kDWOErrorUserInfoKeyExceptionCallStackReturnAddresses;
extern NSString * const kDWOErrorUserInfoKeyExceptionCallStackSymbols;
extern NSString * const kDWOErrorUserInfoKeyExceptionUserInfo;
// [info setValue:exception.name forKey:@"DWOExceptionName"];
//[info setValue:exception.reason forKey:@"DWOExceptionReason"];
//[info setValue:exception.callStackReturnAddresses forKey:@"DWOExceptionCallStackReturnAddresses"];
//[info setValue:exception.callStackSymbols forKey:@"DWOExceptionCallStackSymbols"];
//[info setValue:exception.userInfo forKey:@"DWOExceptionUserInfo"];