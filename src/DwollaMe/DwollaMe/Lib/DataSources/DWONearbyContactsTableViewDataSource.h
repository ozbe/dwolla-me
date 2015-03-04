//
//  DWONearbyContactsTableViewDelegate.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/28/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWONearbyContact.h"

@protocol DWONearbyContactsTableViewDataSourceDelegate;

@interface DWONearbyContactsTableViewDataSource : NSObject

@property (nonatomic, weak) id<DWONearbyContactsTableViewDataSourceDelegate> delegate;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *nearbyContacts;
@property (nonatomic, strong) CLLocation *userLocation;
- (DWONearbyContact *)nearbyContactAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DWONearbyContactsTableViewDataSourceDelegate <NSObject>

@optional

- (void)nearbyContactsTableViewDataSource:(DWONearbyContactsTableViewDataSource *)nearbyContactsTableViewDataSource didSelectNearbyContact:(DWONearbyContact *)nearbyContact;

@end