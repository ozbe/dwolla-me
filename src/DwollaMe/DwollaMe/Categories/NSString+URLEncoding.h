//
//  NSString+URLEncoding.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/16/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end
