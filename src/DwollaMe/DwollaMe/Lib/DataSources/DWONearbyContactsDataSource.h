//
//  DWONearbyContactsDataSource.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/3/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// models
#import "DWONearbyContact.h"
// frameworks
#import <MapKit/MapKit.h>

@protocol DWONearbyContactsDataSourceDelegate;

@interface DWONearbyContactsDataSource : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSNumber *limit;
@property (nonatomic, strong) NSNumber *range;
@property (nonatomic, weak) id<DWONearbyContactsDataSourceDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *nearbyContacts;

- (void)reloadData;
- (void)clearData;

@end

@protocol DWONearbyContactsDataSourceDelegate <NSObject>

@optional

- (void)nearbyContactsDataSourceDidBeginReload:(DWONearbyContactsDataSource *)nearbyContactsDataSource;
- (void)nearbyContactsDataSource:(DWONearbyContactsDataSource *)nearbyContactsDataSource didUpdateNearbyContacts:(NSArray *)nearbyContacts;
- (void)nearbyContactsDataSource:(DWONearbyContactsDataSource *)nearbyContactsDataSource didFinishReloadingWithError:(NSError *)error;

@end