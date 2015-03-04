//
//  DWOContactsClient.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/23/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOContactsClient.h"
// models
#import "DWOContact.h"
#import "DWOUserSearchFilterOption.h"
#import "DWONearbyContact.h"
// constants
#import "DWORestApiConstants.h"
// categories
#import "NSObject+NSNull.h"

@implementation DWOContactsClient

#pragma mark - Public

- (NSArray *)searchContacts:(DWOContactSearchRequest *)request error:(NSError **)error {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                      kDWORequestKeyOAuthToken: self.credentials.token,
                                                                                      kDWORequestKeyContactTerm: request.term,
                                                                                      kDWORequestKeyContactTypes: [self convertToIdTypesValue:request.options],
                                                                                      }];
    
    if (request.limit && [request.limit intValue]) {
        [parameters setObject:[request.limit stringValue] forKey:kDWORequestKeyLimit];
    }
    
    NSDictionary *rawContacts = [self getRelativePath:kDWORelativePathContacts withParameters:parameters error:error];
    
    NSMutableArray *contacts = [NSMutableArray array];
    for (NSDictionary *rawContact in [rawContacts objectForKey:kDWOResponseKeyResponse]) {
        DWOContact *contact = [[DWOContact alloc] init];
        contact.contactId = [rawContact objectForKey:kDWOResponseKeyContactId];
        contact.name = [rawContact objectForKey:kDWOResponseKeyContactName];
        contact.type = [rawContact objectForKey:kDWOResponseKeyContactType];
        contact.imageUrl = [rawContact objectForKey:kDWOResponseKeyImage];
        contact.city = [[rawContact objectForKey:kDWOResponseKeyContactCity] normalizeNull];
        contact.state = [[rawContact objectForKey:kDWOResponseKeyContactState] normalizeNull];
        
        if (contact.name.length) {
            [contacts addObject:contact];
        }
    }
    
    return contacts;
}

- (NSArray *)contactsNearby:(DWONearbyContactsRequest *)request error:(NSError **)error {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                 kDWORequestKeyClientId: self.credentials.key,
                                 kDWORequestKeyClientSecret: self.credentials.secret,
                                 kDWORequestKeyNearbyContactLatitude: [[NSNumber numberWithDouble:request.location.coordinate.latitude] stringValue],
                                 kDWORequestKeyNearbyContactLongitude: [[NSNumber numberWithDouble:request.location.coordinate.longitude] stringValue],
                                 }];
    
    if (request.limit && [request.limit intValue]) {
        [parameters setObject:[NSString stringWithFormat:@"%i", [request.limit intValue]] forKey:kDWORequestKeyLimit];
    }
    
    if (request.range && [request.range intValue]) {
        [parameters setObject:[NSString stringWithFormat:@"%i", [request.range intValue]] forKey:kDWORequestKeyNearbyContactRange];
    }
    
    NSDictionary *rawContacts = [self getRelativePath:kDWORelativePathContactsNearby withParameters:parameters error:error];
    
    NSMutableArray *contacts = [NSMutableArray array];
    for (NSDictionary *rawContact in [rawContacts objectForKey:kDWOResponseKeyResponse]) {
        DWONearbyContact *nearbyContact = [[DWONearbyContact alloc] init];
        nearbyContact.dwollaId = [rawContact objectForKey:kDWOResponseKeyContactId];
        nearbyContact.name = [rawContact objectForKey:kDWOResponseKeyContactName];
        nearbyContact.type = @"Dwolla";
        nearbyContact.address = [rawContact objectForKey:kDWOResponseKeyNearbyContactAddress];
        nearbyContact.city = [rawContact objectForKey:kDWOResponseKeyNearbyContactCity];
        nearbyContact.state = [rawContact objectForKey:kDWOResponseKeyNearbyContactState];
        nearbyContact.imageUrl = [rawContact objectForKey:kDWOResponseKeyImage];
        nearbyContact.location = [self getLocation:rawContact];
        [contacts addObject:nearbyContact];
    }
    
    return contacts;
}

#pragma mark - Private

- (CLLocation *)getLocation:(NSDictionary *)nearbyContact {
    double latitude = [[nearbyContact objectForKey:kDWOResponseKeyNearbyContactLatitude] doubleValue];
    double longitude = [[nearbyContact objectForKey:kDWOResponseKeyNearbyContactLongitude] doubleValue];
    return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}

- (NSString *)convertToIdTypesValue:(DWOUserSearchFilterOptions *)options {
    NSMutableString *value = [NSMutableString string];
    
    for (DWOUserSearchFilterOption *option in options.idTypes) {
        if (!option.enabled) {
            continue;
        }
        
        if (value.length) {
            [value appendString:@","];
        }
        [value appendString:option.name];
    }
    
    return value;
}

@end
