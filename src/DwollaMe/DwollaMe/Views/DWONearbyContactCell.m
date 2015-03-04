//
//  NearbyCell.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/17/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWONearbyContactCell.h"
// frameworks
#import <QuartzCore/QuartzCore.h>
// views
#import "DWOAvatarImageView.h"

@interface DWONearbyContactCell()
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet DWOAvatarImageView *avatarImageView;
@end

@implementation DWONearbyContactCell

- (void)setUser:(DWONearbyContact *)user {
    if (self.user == user) {
        return;
    }
    
    _user = user;
    [self displayUser];
}

- (void)displayUser {
    self.nameLabel.text = self.user ? self.user.name : nil;
    self.avatarImageView.imageUrl = self.user ? self.user.imageUrl : nil;
    self.locationLabel.text = [self nearbyUserLocation];
    [self displayDistance];
}

- (void)displayDistance {
    if (self.user && [self.delegate respondsToSelector:@selector(nearbyCell:distanceToNearbyContact:)]) {
        self.distanceLabel.text = [self formattedDistance];
        self.distanceLabel.layer.cornerRadius = 3;
    } else {
        self.distanceLabel.hidden = YES;
    }
}

- (NSString *)formattedDistance {
    CLLocationDistance distance = [self.delegate nearbyCell:self distanceToNearbyContact:self.user];
    return [self formattedDistance:distance];
}

-(NSString *)formattedDistance:(CLLocationDistance)distance {
    double miles = distance / 5280;
    
    if (miles > 0.1) {
        return [NSString stringWithFormat:@"%0.01fmi", miles];
    } else {
        return [NSString stringWithFormat:@"%dft", (int)distance];
    }
}

- (NSString *)nearbyUserLocation {
    return self.user ? self.user.address : nil;
}

@end
