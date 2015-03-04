//
//  NSDate+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 1/7/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "NSDate+Dwolla.h"

@implementation NSDate (Dwolla)

- (NSString *)shortDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)longDateTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)ago {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:self
                                                  toDate:[NSDate date]
                                                 options:0];
    if ([components day] > 7) {
        return [self shortDate];
    } else if ([components day] >= 1) {
        return [NSString stringWithFormat:@"%lid", (long)[components day]];
    } else if ([components hour] < 1) {
        return [NSString stringWithFormat:@"%lim", (long)[components minute]];
    } else {
        return [NSString stringWithFormat:@"%lih", (long)[components hour]];
    }
}

@end
