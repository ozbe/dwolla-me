//
//  DWONearbyContactAnnotation.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/20/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// frameworks
#import <MapKit/MapKit.h>
// models
#import "DWONearbyContact.h"

@interface DWONearbyContactAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) DWONearbyContact *nearbyContact;

- (instancetype)initWithNearbyContact:(DWONearbyContact *)nearbyContact;

@end
