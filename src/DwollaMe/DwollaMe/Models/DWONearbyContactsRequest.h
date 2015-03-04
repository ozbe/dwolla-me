//
//  DWONearbyContactsRequest.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/3/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// frameworks
#import <CoreLocation/CoreLocation.h>

@interface DWONearbyContactsRequest : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSNumber *range;

@end
