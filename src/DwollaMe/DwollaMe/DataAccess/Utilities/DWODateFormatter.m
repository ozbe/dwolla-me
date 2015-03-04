//
//  DWODateFormatter.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/16/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWODateFormatter.h"

@interface DWODateFormatter ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DWODateFormatter

#pragma mark - Properties

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        
    }
    return _dateFormatter;
}

#pragma mark - Public

- (NSDate *)dateFromLongString:(NSString *)string {
    [self.dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    return [self.dateFormatter dateFromString:string];
}

- (NSDate *)dateFromShortString:(NSString *)string {
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    return [self.dateFormatter dateFromString:string];

}

@end
