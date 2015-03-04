//
//  DWODateFormatter.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/16/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

@interface DWODateFormatter : NSObject

- (NSDate *)dateFromLongString:(NSString *)string;
- (NSDate *)dateFromShortString:(NSString *)string;

@end
