//
//  DWOAppDelegate.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/7/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWOAppDelegate.h"
// vendors
#import "TestFlight.h"
// categories
#import "UIColor+Dwolla.h"
// data access
#import "DWOCredentials.h"
// constants
#import "DWOAppConstants.h"

@implementation DWOAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DWOCredentials *credentials = [DWOCredentials sharedCredentials];
    credentials.key = kDWOClientKey;
    credentials.secret = kDWOClientSecret;
    
    self.window.tintColor = [UIColor dwollaOrangeColor];
    self.window.hidden = NO;
    return YES;
}

@end
