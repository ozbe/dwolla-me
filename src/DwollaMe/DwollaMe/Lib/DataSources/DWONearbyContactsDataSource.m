//
//  DWONearbyContactsDataSource.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/3/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWONearbyContactsDataSource.h"
// models
#import "DWONearbyContact.h"
// data access
#import "DWOContactsClient.h"

@interface DWONearbyContactsDataSource ()
@property (nonatomic, strong) NSOperationQueue *nearbyContactsQueue;
@property (nonatomic, strong) DWOContactsClient *contactsClient;
@property (nonatomic, strong) NSArray *nearbyContacts;
@end

@implementation DWONearbyContactsDataSource

#pragma mark - Properties

@synthesize nearbyContacts = _nearbyContacts;

- (NSOperationQueue *)nearbyContactsQueue {
    if (!_nearbyContactsQueue) {
        _nearbyContactsQueue = [[NSOperationQueue alloc] init];
        _nearbyContactsQueue.name = @"Nearby Contacts Queue";
        _nearbyContactsQueue.maxConcurrentOperationCount = 1;
    }
    return _nearbyContactsQueue;
}

- (DWOContactsClient *)contactsClient {
    if (!_contactsClient) {
        _contactsClient = [[DWOContactsClient alloc] init];
    }
    return _contactsClient;
}

- (NSArray *)nearbyContacts {
    if (!_nearbyContacts) {
        _nearbyContacts = [NSArray array];
    }
    return _nearbyContacts;
}

- (void)setNearbyContacts:(NSArray *)nearbyContacts {
    _nearbyContacts = nearbyContacts;
    [self notifyDelegateDidUpdateNearbyContacts];
}

#pragma mark - Public

- (void)reloadData {
    [self fetchAndSetNearbyContacts];
}

- (void)clearData {
    self.nearbyContacts = nil;
}

#pragma mark - Private

- (void)fetchAndSetNearbyContacts {
    [self.nearbyContactsQueue cancelAllOperations];
    
    __weak DWONearbyContactsDataSource *self_weak = self;
    
    [self notifyDelegateDidBeginReload];

    [self.nearbyContactsQueue addOperationWithBlock:^{
        NSError *error;
        NSArray *nearbyContacts = [self_weak fetchNearbyContactsOrReturnError:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // handle error
            self_weak.nearbyContacts = nearbyContacts;
        }];
    }];
}

- (NSArray *)fetchNearbyContactsOrReturnError:(NSError **)error {
    DWONearbyContactsRequest *request = [self createNearbyContactsRequest];
    return [self.contactsClient contactsNearby:request error:error];
}

- (DWONearbyContactsRequest *)createNearbyContactsRequest {
    DWONearbyContactsRequest *request = [[DWONearbyContactsRequest alloc] init];
    request.location = self.location;
    request.limit = self.limit;
    request.range = self.range;
    return request;
}

- (void)notifyDelegateDidBeginReload {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsDataSourceDidBeginReload:)]) {
        [self.delegate nearbyContactsDataSourceDidBeginReload:self];
    }
}

- (void)notifyDelegateDidUpdateNearbyContacts {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsDataSource:didUpdateNearbyContacts:)]) {
        [self.delegate nearbyContactsDataSource:self didUpdateNearbyContacts:self.nearbyContacts];
    }
}

@end
