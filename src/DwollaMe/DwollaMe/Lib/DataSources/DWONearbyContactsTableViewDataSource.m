//
//  DWONearbyContactsTableViewDelegate.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/28/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWONearbyContactsTableViewDataSource.h"
// views
#import "DWONearbyContactCell.h"

@interface DWONearbyContactsTableViewDataSource () <DWONearbyCellDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *sortedNearbyContacts;
@end

@implementation DWONearbyContactsTableViewDataSource

#pragma mark - Properties

- (void)setTableView:(UITableView *)tableView {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)setNearbyContacts:(NSArray *)nearbyContacts {
    _nearbyContacts = nearbyContacts;
    self.sortedNearbyContacts = [self sortNearbyContacts];
}

#pragma mark - Public

- (DWONearbyContact *)nearbyContactAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < self.sortedNearbyContacts.count) ? [self.sortedNearbyContacts objectAtIndex:indexPath.row] : nil;
}

#pragma mark - Private

- (NSArray *)sortNearbyContacts {
    return [self.nearbyContacts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        DWONearbyContact *c1 = (DWONearbyContact*)obj1;
        DWONearbyContact *c2 = (DWONearbyContact*)obj2;
        
        CLLocationDistance d1 = [self getDistance:c1];
        CLLocationDistance d2 = [self getDistance:c2];
        
        if (d1 > d2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (d1 < d2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)notifyDelegateDidSelectNearbyContact:(DWONearbyContact *)nearbyContact {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsTableViewDataSource:didSelectNearbyContact:)]) {
        [self.delegate nearbyContactsTableViewDataSource:self didSelectNearbyContact:nearbyContact];
    }
}

- (CLLocationDistance)getDistance:(DWONearbyContact *)contact {
    CLLocationDistance distanceInMeters = [self.userLocation distanceFromLocation:contact.location];
    return distanceInMeters * 3.28084;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self notifyDelegateDidSelectNearbyContact:[self nearbyContactAtIndexPath:indexPath]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sortedNearbyContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWONearbyContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nearby Cell"];
    cell.delegate = self;
    cell.user = [self nearbyContactAtIndexPath:indexPath];
    return cell;
}

#pragma mark - DWONearbyCellDelegate

- (CLLocationDistance)nearbyCell:(DWONearbyContactCell *)nearbyCell distanceToNearbyContact:(DWONearbyContact *)contact {
    return [self getDistance:contact];
}

@end
