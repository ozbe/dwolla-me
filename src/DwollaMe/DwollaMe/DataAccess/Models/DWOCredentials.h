//
//  DwollaCredentials.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/16/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

@interface DWOCredentials : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *baseUrl;

+ (DWOCredentials *)sharedCredentials;

@end
