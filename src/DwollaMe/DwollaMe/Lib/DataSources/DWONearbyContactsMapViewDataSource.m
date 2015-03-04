//
//  DWONearbyContactsMapViewDelegate.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/28/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWONearbyContactsMapViewDataSource.h"
// models
#import "DWONearbyContactAnnotation.h"
// views
#import "DWOAvatarImageView.h"

@interface DWONearbyContactsMapViewDataSource () <MKMapViewDelegate>
@property (nonatomic, strong) NSArray *annotations;
@end

@implementation DWONearbyContactsMapViewDataSource

#pragma mark - Properties

- (void)setNearbyContacts:(NSArray *)nearbyContacts {
    _nearbyContacts = nearbyContacts;
    self.annotations = [self convertNearbyContactsToMapAnnotations];
}

- (void)setMapView:(MKMapView *)mapView {
    self.mapView.delegate = nil;
    _mapView = mapView;
    self.mapView.delegate = self;
    [self.mapView addAnnotations:self.annotations];
    [self notifyDelegateDidUpdateAnnotations];
}

- (void)setAnnotations:(NSArray *)annotations {
    [self.mapView removeAnnotations:self.annotations];
    _annotations = annotations;
    [self.mapView addAnnotations:self.annotations];
    [self notifyDelegateDidUpdateAnnotations];
}

#pragma mark - Private

- (NSArray *)convertNearbyContactsToMapAnnotations {
    NSMutableArray *annotations = [NSMutableArray array];
    
    for (DWONearbyContact *contact in self.nearbyContacts) {
        [annotations addObject:[[DWONearbyContactAnnotation alloc] initWithNearbyContact:contact]];
    }
    
    return annotations;
}

- (void)notifyDelegateDidSelectNearbyContact:(DWONearbyContact *)nearbyContact {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsMapViewDataSource:didSelectNearbyContact:)]) {
        [self.delegate nearbyContactsMapViewDataSource:self didSelectNearbyContact:nearbyContact];
    }
}

- (void)notifyDelegateDidUpdateAnnotations {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsMapViewDataSource:didUpdateAnnotations:)]) {
        [self.delegate nearbyContactsMapViewDataSource:self didUpdateAnnotations:self.annotations];
    }
}

- (void)notifyDelegateDidUpdateRegion {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsMapViewDataSource:didUpdateRegion:)]) {
        [self.delegate nearbyContactsMapViewDataSource:self didUpdateRegion:self.mapView.region];
    }
}

- (void)notifyDelegateDidUpdateUserLocation {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsMapViewDataSource:didUpdateUserLocation:)]) {
        [self.delegate nearbyContactsMapViewDataSource:self didUpdateUserLocation:self.mapView.userLocation];
    }
}

- (void)notifyDelegateDidFailToLocateUserWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(nearbyContactsMapViewDataSource:didFailToLocateUserWithError:)]) {
        [self.delegate nearbyContactsMapViewDataSource:self didFailToLocateUserWithError:error];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self notifyDelegateDidUpdateUserLocation];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [self notifyDelegateDidFailToLocateUserWithError:error];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self notifyDelegateDidUpdateRegion];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if (![view.annotation isKindOfClass:[DWONearbyContactAnnotation class]]) {
        return;
    }
    
    DWONearbyContactAnnotation *annotation = (DWONearbyContactAnnotation *)view.annotation;
    [self notifyDelegateDidSelectNearbyContact:annotation.nearbyContact];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (![view.annotation isKindOfClass:[DWONearbyContactAnnotation class]]) {
        return;
    }
    
    DWOAvatarImageView *avatarImageView = (DWOAvatarImageView *)view.leftCalloutAccessoryView;
    DWONearbyContactAnnotation *nearbyContactAnnotation = (DWONearbyContactAnnotation *)view.annotation;
    avatarImageView.imageUrl = nearbyContactAnnotation.nearbyContact.imageUrl;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (![annotation isKindOfClass:[DWONearbyContactAnnotation class]]) {
        return nil;
    }
    
    static NSString *AnnotationIdentifier = @"Annotation Identifier";
    
    MKAnnotationView *pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (pinView == nil) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        pinView.image = [UIImage imageNamed:@"Pin"];
        CGRect frame = pinView.frame;
        frame.size.height = 32;
        frame.size.width = 24;
        pinView.frame = frame;
        pinView.canShowCallout = YES;
        
        DWOAvatarImageView *avatarImageView = [[DWOAvatarImageView alloc] initWithFrame:CGRectMake(0,0,31,31)];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"ArrowRight"] forState:UIControlStateNormal];
        [rightButton setFrame:CGRectMake(0,0,32,32)];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        
        pinView.leftCalloutAccessoryView = avatarImageView;
        pinView.rightCalloutAccessoryView = rightButton;
    } else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

@end
