//
//  MainViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 1/14/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOMainViewController.h"
// data access
#import "DWOUsersClient.h"
// view controllers
#import "DWOOAuthViewController.h"
// vendors
#import "TestFlight.h"

@interface DWOMainViewController () <DWOOAuthViewControllerDelegate>
{
    BOOL isInitialLoad;
}
@property (nonatomic, strong) DWOUsersClient *usersRepository;
@property (nonatomic, assign) BOOL isTokenValid;
@end

@implementation DWOMainViewController

#pragma mark - Properties

- (DWOUsersClient *)usersRepository {
    if (!_usersRepository) {
        _usersRepository = [[DWOUsersClient alloc] init];
    }
    return _usersRepository;
}

#pragma mark - Private

- (void)logoutNotification:(NSNotification *)notfication {
    [TestFlight passCheckpoint:@"Logged out"];
    [DWOCredentials sharedCredentials].token = nil;
    [self performSegueWithIdentifier:@"Logout" sender:self];
}

#pragma mark - Overrides

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        isInitialLoad = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotification:) name:@"logout" object:nil];
    self.isTokenValid = [DWOCredentials sharedCredentials].token && [self.usersRepository isTokenValid];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isInitialLoad) {
        isInitialLoad = NO;

        if (!self.isTokenValid) {
            [self performSegueWithIdentifier:@"Logout" sender:self];
        } else {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"auth" object:nil]];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"logout" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Logout"]) {
        UINavigationController *navViewController = (UINavigationController *)segue.destinationViewController;
        DWOOAuthViewController *oauthViewController = (DWOOAuthViewController *)navViewController.topViewController;
        oauthViewController.delegate = self;
    }
}

#pragma mark - OAuthViewControllerDelegate

- (void)loggedInWithOAuthViewController:(DWOOAuthViewController *)oAuthViewController {
    [TestFlight passCheckpoint:@"Logged in"];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"auth" object:nil]];
    self.selectedIndex = 0;
    [oAuthViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
