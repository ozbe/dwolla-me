//
//  DWONearbyContactsMapViewDelegate.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/28/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// frameworks
#import <MapKit/MapKit.h>
// models
#import "DWONearbyContact.h"

@protocol DWONearbyContactsMapViewDataSourceDelegate;

@interface DWONearbyContactsMapViewDataSource : NSObject

@property (nonatomic, weak) id<DWONearbyContactsMapViewDataSourceDelegate> delegate;
@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) NSArray *nearbyContacts;
@property (nonatomic, strong, readonly) NSArray *annotations;

@end

@protocol DWONearbyContactsMapViewDataSourceDelegate <NSObject>

@optional

- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didUpdateAnnotations:(NSArray *)annotations;
- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didUpdateRegion:(MKCoordinateRegion)region;
- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didSelectNearbyContact:(DWONearbyContact *)nearbyContact;
- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didUpdateUserLocation:(MKUserLocation *)userLocation;
- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didFailToLocateUserWithError:(NSError *)error;

@end