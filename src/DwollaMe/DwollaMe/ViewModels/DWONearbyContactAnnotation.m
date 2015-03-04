//
//  DWONearbyContactAnnotation.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/20/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWONearbyContactAnnotation.h"

@implementation DWONearbyContactAnnotation

- (instancetype)initWithNearbyContact:(DWONearbyContact *)nearbyContact {
    self = [super init];
    
    if (self) {
        self.nearbyContact = nearbyContact;
    }
    
    return self;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
    return [self.nearbyContact.location coordinate];
}

- (NSString *)title {
    return self.nearbyContact.name;
}

@end
