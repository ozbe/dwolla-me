//
//  DWOUser.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/28/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// frameworks
#import <CoreLocation/CoreLocation.h>

#warning this should be account, not user

@interface DWOUser : NSObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *type;

@end
