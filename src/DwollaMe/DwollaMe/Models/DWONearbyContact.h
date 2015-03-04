//
//  DWONearbyUser.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/16/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// frameworks
#import <CoreLocation/CoreLocation.h>

@interface DWONearbyContact : NSObject

@property (nonatomic, strong) NSString *dwollaId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) CLLocation *location;

@end
