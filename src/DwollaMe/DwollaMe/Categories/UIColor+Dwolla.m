//
//  UIColor+Dwolla.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "UIColor+Dwolla.h"

@implementation UIColor (Dwolla)

+ (UIColor *)dwollaOrangeColor {
    return [UIColor colorWithRed:255.0/255
                           green:127.0/255
                            blue:0
                           alpha:1];
}

+ (UIColor *)dwollaGrayColor {
    return [UIColor colorWithRed:196.0/255
                           green:199.0/255
                            blue:207.0/255
                           alpha:1];
}

+ (UIColor *)dwollaGreenColor {
    return [UIColor colorWithRed:0 green:153.0/255 blue:0 alpha:1];
}

+ (UIColor *)dwollaRedColor {
    return [UIColor colorWithRed:192.0/255 green:80.0/255 blue:77.0/255 alpha:1];
}

@end
