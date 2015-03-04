//
//  NearbyCell.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/17/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import <UIKit/UIKit.h>
// models
#import "DWONearbyContact.h"

@protocol DWONearbyCellDelegate;

@interface DWONearbyContactCell : UITableViewCell

@property (nonatomic, weak) id<DWONearbyCellDelegate> delegate;
@property (nonatomic, weak) DWONearbyContact *user;

@end

@protocol DWONearbyCellDelegate <NSObject>

@optional

- (CLLocationDistance)nearbyCell:(DWONearbyContactCell *)nearbyCell distanceToNearbyContact:(DWONearbyContact *)contact;

@end