//
//  SearchViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/5/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOSearchViewController.h"
// view controllers
#import "DWOSearchFilterViewController.h"
#import "DWOTransferViewController.h"
// models
#import "DWOUserSearchFilterOptions.h"
#import "DWOContactsDataSource.h"
#import "DWONearbyContactsDataSource.h"
#import "DWONearbyContactsTableViewDataSource.h"
#import "DWONearbyContactsMapViewDataSource.h"
// views
#import "DWONearbyContactCell.h"
#import "DWOContactCell.h"
// categories
#import "UIColor+Dwolla.h"
#import "DWOContact+Dwolla.h"
#import "DWONearbyContact+Dwolla.h"
// constants
#import "DWOSegueConstants.h"
// frameworks
#import <MapKit/MapKit.h>
// vendors
#import "TestFlight.h"

@interface DWOSearchViewController ()
    <DWOContactsDataSourceDelegate, DWONearbyContactsDataSourceDelegate, DWONearbyContactsMapViewDataSourceDelegate, DWONearbyContactsTableViewDataSourceDelegate, DWOSearchFilterViewControllerDelegate, DWOTransferViewControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *redoSearchInAreaView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIBarButtonItem *showAnnotationsBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;
@property (strong, nonatomic) UITapGestureRecognizer *mapTapGesture;

@property (nonatomic, strong) DWOContactsDataSource *contactsDataSource;
@property (strong, nonatomic) DWONearbyContactsDataSource *nearbyContactsDataSource;
@property (strong, nonatomic) DWONearbyContactsTableViewDataSource *nearbyContactsTableViewDataSource;
@property (strong, nonatomic) DWONearbyContactsMapViewDataSource *nearbyContactsMapViewDataSource;

@property (nonatomic, assign) dispatch_once_t onceToken;
@property (nonatomic, assign) BOOL isReloadSearchPending;
@property (nonatomic, assign) CGFloat mapViewShortHeight;
@property (nonatomic, assign) BOOL isMapInitialized;
@property (nonatomic, assign) BOOL mapUserHasFired;
@property (nonatomic, assign) BOOL isUpdatingRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation DWOSearchViewController

#pragma mark - Properties

- (DWOContactsDataSource *)contactsDataSource {
    if (!_contactsDataSource) {
        _contactsDataSource = [[DWOContactsDataSource alloc] init];
    }
    return _contactsDataSource;
}

- (DWONearbyContactsDataSource *)nearbyContactsDataSource {
    if (!_nearbyContactsDataSource) {
        _nearbyContactsDataSource = [[DWONearbyContactsDataSource alloc] init];
    }
    return _nearbyContactsDataSource;
}

- (DWONearbyContactsTableViewDataSource *)nearbyContactsTableViewDataSource {
    if (!_nearbyContactsTableViewDataSource) {
        _nearbyContactsTableViewDataSource = [[DWONearbyContactsTableViewDataSource alloc] init];
    }
    return _nearbyContactsTableViewDataSource;
}

- (DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource {
    if (!_nearbyContactsMapViewDataSource) {
        _nearbyContactsMapViewDataSource = [[DWONearbyContactsMapViewDataSource alloc] init];
    }
    return _nearbyContactsMapViewDataSource;
}

- (UIBarButtonItem *)doneBarButtonItem {
    if (!_doneBarButtonItem) {
        _doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithMap:)];
    }
    return _doneBarButtonItem;
}

- (UIBarButtonItem *)showAnnotationsBarButtonItem {
    if (!_showAnnotationsBarButtonItem) {
        _showAnnotationsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LocationArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(setUserLocationOnNearbyContactsDataSource:)];
    }
    return _showAnnotationsBarButtonItem;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

#pragma mark - Private

- (void)safelyResignSearchBar {
    if (self.searchDisplayController.searchBar.isFirstResponder) {
        [self.searchDisplayController.searchBar resignFirstResponder];
    }
}

- (void)didSelectNearbyContact:(DWONearbyContact *)nearbyContact {
    [self performSegueWithIdentifier:kDWSegueSendToNearby sender:nearbyContact];
}

- (void)showRedoSearchInAreaView {
    if (self.mapTapGesture.enabled) {
        return;
    }
    
    self.redoSearchInAreaView.alpha = 1;
    [UIView animateWithDuration:.2 animations:^{
        CGPoint center = self.redoSearchInAreaView.center;
        center.y = self.view.frame.size.height - self.redoSearchInAreaView.frame.size.height / 2;
        self.redoSearchInAreaView.center = center;
    } completion:nil];
}

- (void)hideRedoSearchInAreaView {
    [UIView animateWithDuration:.2 animations:^{
        CGPoint center = self.redoSearchInAreaView.center;
        center.y = self.view.frame.size.height + self.redoSearchInAreaView.frame.size.height / 2;
        self.redoSearchInAreaView.center = center;
    } completion:^(BOOL finished) {
        self.redoSearchInAreaView.alpha = 0;
    }];
}

- (void)setRegionOnNearbyContactsDataSource {
    self.nearbyContactsDataSource.location = [[CLLocation alloc] initWithLatitude:self.mapView.region.center.latitude longitude:self.mapView.region.center.longitude];
    self.nearbyContactsDataSource.range = [NSNumber numberWithDouble:self.mapView.region.span.latitudeDelta * 69.0];
    [self.nearbyContactsDataSource reloadData];
}

- (void)showAllMapAnnotations {
    self.isUpdatingRegion = YES;
    
    if (self.mapView.userLocation.location == self.nearbyContactsDataSource.location) {
        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    } else {
        [self.mapView showAnnotations:self.nearbyContactsMapViewDataSource.annotations animated:YES];
    }
    [self hideRedoSearchInAreaView];
}

- (void)setUserLocationOnNearbyContactsDataSource {
    self.nearbyContactsDataSource.location = self.mapView.userLocation.location;
    [self.nearbyContactsDataSource reloadData];
}

- (void)adjustOffsetToShowRefresh:(void (^)(BOOL finished))handler {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
        self.tableView.contentOffset = CGPointMake(0, self.tableView.contentOffset.y -self.refreshControl.frame.size.height);
    } completion:handler];
}

#pragma mark - Events

- (IBAction)redoSearchInArea:(id)sender {
    [self setRegionOnNearbyContactsDataSource];
    [self hideRedoSearchInAreaView];
}

- (IBAction)cancelSearch:(id)sender {
    self.searchDisplayController.active = NO;
}

- (void)handleTapOnTableView:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self.tableView];
        
        if (point.y <= 0) {
            [self handleTapOnMap:nil];
        }
    }
}

- (void)handleTapOnMap:(id)sender {
    [TestFlight passCheckpoint:@"Display map"];
    
    self.mapTapGesture.enabled = NO;
    self.mapView.scrollEnabled = YES;
    self.mapView.zoomEnabled = YES;
    self.navigationItem.leftBarButtonItem = self.doneBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.showAnnotationsBarButtonItem;
    self.navigationItem.titleView.alpha = 0;
    
    self.isUpdatingRegion = YES;
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.mapView.frame = CGRectMake(0, 0, self.mapView.frame.size.width, self.view.frame.size.height);
                         self.tableView.center = CGPointMake(self.tableView.center.x, self.view.frame.size.height + self.tableView.frame.size.height / 2);
                     }
                     completion:^(BOOL finished) {
                         [self showAllMapAnnotations];
                     }];
}

- (IBAction)setUserLocationOnNearbyContactsDataSource:(id)sender {
    self.isUpdatingRegion = YES;
    [self setUserLocationOnNearbyContactsDataSource];
}

- (IBAction)doneWithMap:(id)sender {
    for (id<MKAnnotation> annotation in self.mapView.selectedAnnotations) {
        [self.mapView deselectAnnotation:annotation animated:YES];
    }
    self.mapTapGesture.enabled = YES;
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.titleView.alpha = 1;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    self.isUpdatingRegion = YES;
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.mapView.frame = CGRectMake(0, 0, self.mapView.frame.size.width, self.mapViewShortHeight);
                         self.tableView.center = self.view.center;
                     }
                     completion:^(BOOL finished) {
                         [self showAllMapAnnotations];
                     }];
}

- (void)appWillEnterForeground:(id)sender {
    [self setUserLocationOnNearbyContactsDataSource];
}

#pragma mark - Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isUpdatingRegion = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.nearbyContactsDataSource.delegate = self;
    self.nearbyContactsDataSource.limit = @30;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.nearbyContactsTableViewDataSource.delegate = self;
    self.nearbyContactsTableViewDataSource.tableView = self.tableView;
    UIEdgeInsets tableViewContentInset = self.tableView.contentInset;
    tableViewContentInset.top = self.mapView.frame.size.height;
    self.tableView.contentInset = tableViewContentInset;
    UITapGestureRecognizer *tableViewHeaderTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnTableView:)];
    tableViewHeaderTapGesture.numberOfTapsRequired = 1;
    tableViewHeaderTapGesture.numberOfTouchesRequired = 1;
    tableViewHeaderTapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewHeaderTapGesture];

    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    self.mapTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMap:)];
    self.mapTapGesture.numberOfTapsRequired = 1;
    self.mapTapGesture.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:self.mapTapGesture];
    self.nearbyContactsMapViewDataSource.delegate = self;
    self.nearbyContactsMapViewDataSource.mapView = self.mapView;
    self.mapViewShortHeight = self.mapView.frame.size.height;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor dwollaOrangeColor];
    [self.refreshControl addTarget:self action:@selector(refreshValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.contactsDataSource.delegate = self;
    self.contactsDataSource.tableView = self.searchDisplayController.searchResultsTableView;
    self.searchDisplayController.searchBar.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self.contactsDataSource;
    self.searchDisplayController.searchResultsDelegate = self.contactsDataSource;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;

    self.redoSearchInAreaView.alpha = 0;
    self.locationManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

#warning HACK - done so the constraints don't move the table view when showing map view, find a better way
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.redoSearchInAreaView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    dispatch_once(&_onceToken, ^{
        [self hideRedoSearchInAreaView];
        
		[self adjustOffsetToShowRefresh:^(BOOL finished) {
            [self.locationManager requestWhenInUseAuthorization];
        }];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.refreshControl endRefreshing];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Filter"]) {
        UINavigationController *navController = segue.destinationViewController;
        DWOSearchFilterViewController *filter = (DWOSearchFilterViewController *)navController.topViewController;
        filter.delegate = self;
        filter.filterOptions = self.contactsDataSource.filterOptions;
    } else if ([segue.identifier isEqualToString:kDWSegueSendToNearby]) {
        UINavigationController *navController = segue.destinationViewController;
        DWOTransferViewController *sendVC = (DWOTransferViewController *)navController.topViewController;
        sendVC.delegate = self;
        
        DWONearbyContact *nearby = (DWONearbyContact *)sender;
        sendVC.transferStrategy = [nearby convertToSendStrategy];
    } else if ([segue.identifier isEqualToString:kDWSegueSendToContact]) {
        UINavigationController *navController = segue.destinationViewController;
        DWOTransferViewController *sendVC = (DWOTransferViewController *)navController.topViewController;
        sendVC.delegate = self;

        DWOContact *contact = (DWOContact *)sender;
        sendVC.transferStrategy = [contact convertToSendStrategy];
    }
}

#pragma mark - SendViewControllerDelegate

- (void)sendViewController:(DWOTransferViewController *)sendViewController cancelled:(DWOSendRequest *)request {
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendViewController:(DWOTransferViewController *)sendViewController sent:(DWOSendRequest *)sent response:(DWOSendResponse *)response {
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DWOContactsDataSourceDelegate

- (void)contactsDataSourceDidFinishSearching:(DWOContactsDataSource *)contactsDataSource {
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)contactsDataSource:(DWOContactsDataSource *)contactsDataSource didSelectContact:(DWOContact *)contact {
    [self performSegueWithIdentifier:kDWSegueSendToContact sender:contact];
}

#pragma mark - DWONearbyContactsDataSourceDelegate

- (void)nearbyContactsDataSourceDidBeginReload:(DWONearbyContactsDataSource *)nearbyContactsDataSource {
    [self.refreshControl beginRefreshing];
}

- (void)nearbyContactsDataSource:(DWONearbyContactsDataSource *)nearbyContactsDataSource didUpdateNearbyContacts:(NSArray *)nearbyContacts {
    [self.refreshControl endRefreshing];
    self.nearbyContactsMapViewDataSource.nearbyContacts = nearbyContacts;
    self.nearbyContactsTableViewDataSource.nearbyContacts = nearbyContacts;
    [self.tableView reloadData];
}

- (void)nearbyContactsDataSource:(DWONearbyContactsDataSource *)nearbyContactsDataSource didFinishReloadingWithError:(NSError *)error {
    // handle error
}

#pragma mark - DWONearbyContactsMapViewDataSourceDelegate

- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didFailToLocateUserWithError:(NSError *)error {
    // focus on the office
}

- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didSelectNearbyContact:(DWONearbyContact *)nearbyContact {
    [self didSelectNearbyContact:nearbyContact];
}

- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didUpdateAnnotations:(NSArray *)annotations {
    [self showAllMapAnnotations];
}

- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didUpdateRegion:(MKCoordinateRegion)region {
    if (self.isUpdatingRegion) {
        self.isUpdatingRegion = NO;
    } else {
        [self showRedoSearchInAreaView];
    }
}

- (void)nearbyContactsMapViewDataSource:(DWONearbyContactsMapViewDataSource *)nearbyContactsMapViewDataSource didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.nearbyContactsTableViewDataSource.userLocation = userLocation.location;
    
    if (!self.isMapInitialized) {
        self.isMapInitialized = YES;
        self.isUpdatingRegion = YES;
        [self setUserLocationOnNearbyContactsDataSource];
    }
}

#pragma mark - DWONearbyContactsTableViewDataSourceDelegate

- (void)nearbyContactsTableViewDataSource:(DWONearbyContactsTableViewDataSource *)nearbyContactsTableViewDataSource didSelectNearbyContact:(DWONearbyContact *)nearbyContact {
    [self didSelectNearbyContact:nearbyContact];
}

#pragma mark - SearchFilterViewControllerDelegate

- (void)dismissSearchFilterViewController:(DWOSearchFilterViewController *)searchFilterViewController {
    [searchFilterViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.isReloadSearchPending) {
        self.isReloadSearchPending = NO;
        [self.contactsDataSource refreshData];
    }
}

- (DWOUserSearchFilterOptions *)filterOptionsForSearchFilter:(DWOSearchFilterViewController *)searchFilter {
    return self.contactsDataSource.filterOptions;
}

- (void)searchFilterViewController:(DWOSearchFilterViewController *)searchFilter searchFilterOption:(DWOUserSearchFilterOption *)searchFilterOption enabled:(BOOL)enabled {
    self.isReloadSearchPending = YES;
}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [TestFlight passCheckpoint:@"Started search"];
    self.navigationItem.leftBarButtonItem = self.filterBarButtonItem;
    self.navigationItem.rightBarButtonItem = self.cancelBarButtonItem;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.searchDisplayController.searchBar.text = nil;
    [self.contactsDataSource clearData];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.contactsDataSource.searchText = searchText;
}

#pragma mark - UIRefreshControlDelegate

- (IBAction)refreshValueChanged:(UIRefreshControl *)sender {
    if (sender.isRefreshing) {
        [self.nearbyContactsDataSource reloadData];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized ||
        status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
        [self.refreshControl beginRefreshing];
    }
}

@end
