//
//  DWORequestsViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/22/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWORequestsViewController.h"
// categories
#import "DWOTransactionCell+DWOMoneyRequest.h"
#import "UIColor+Dwolla.h"
#import "DWOMoneyRequest+Dwolla.h"
#import "NSError+Dwolla.h"
// lib
#import "DWOMoneyRequestsDataSource.h"
// view controllers
#import "DWORequestViewController.h"
#import "DWOTransferViewController.h"
// data access
#import "DWOUsersClient.h"
#import "DWOMoneyRequestsClient.h"
// vendors
#import "SVProgressHUD.h"

@interface DWORequestsViewController () <DWOMoneyRequestsDataSourceDelegate, DWORequestViewControllerDelegate, DWOTransferViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *infiniteActivityIndicator;
@property (weak, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, assign) dispatch_once_t onceToken;
@property (nonatomic, strong) DWOMoneyRequestsDataSource *moneyRequestDataSource;
@property (nonatomic, strong) DWOUsersClient *usersClient;
@property (nonatomic, strong) DWOMoneyRequestsClient *moneyRequestsClient;
@property (nonatomic, strong) DWOUser *user;
@property (nonatomic, strong) NSOperationQueue *requestQueue;
@end

@implementation DWORequestsViewController

#pragma mark - Static

#define SEND_SEGUE @"Send"
#define REQUEST_SEGUE @"Request"
#define CONFIRM_ALERT_BUTTON_INDEX 1

#pragma mark - Properties

- (DWOMoneyRequestsDataSource *)moneyRequestDataSource {
    if (!_moneyRequestDataSource) {
        _moneyRequestDataSource = [[DWOMoneyRequestsDataSource alloc] initWithConfigureCellBlock:^(DWOTransactionCell *cell, DWOMoneyRequest *moneyRequest) {
            [cell setMoneyRequest:moneyRequest accountId:self.user.accountId];
        }];
    }
    return _moneyRequestDataSource;
}

- (DWOUsersClient *)usersClient {
    if (!_usersClient) {
        _usersClient = [[DWOUsersClient alloc] init];
    }
    return _usersClient;
}

- (DWOMoneyRequestsClient *)moneyRequestsClient {
    if (!_moneyRequestsClient) {
        _moneyRequestsClient = [[DWOMoneyRequestsClient alloc] init];
    }
    return _moneyRequestsClient;
}

- (DWOUser *)user {
    if (!_user) {
        NSError *error;
        _user = [self.usersClient userOrError:&error];
    }
    return _user;
}

- (NSOperationQueue *)requestQueue {
    if (!_requestQueue) {
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 1;
        _requestQueue.name = @"Request Queue";
    }
    return _requestQueue;
}

#pragma mark - Private

- (void)fulfillRequest:(DWOMoneyRequest *)moneyRequest {
    [self performSegueWithIdentifier:SEND_SEGUE sender:moneyRequest];
}

- (void)declineMoneyRequest:(DWOMoneyRequest *)moneyRequest {
    __weak DWORequestsViewController *self_weak = self;
    
    [SVProgressHUD showWithStatus:@"Processing" maskType:SVProgressHUDMaskTypeClear];
    
    [self.requestQueue addOperationWithBlock:^{
        NSError *error;
        [self_weak.moneyRequestsClient cancelRequest:moneyRequest.requestId error:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD dismiss];

            if (!error) {
                [self_weak.navigationController popToViewController:self_weak animated:YES];
                [self_weak.moneyRequestDataSource refreshData];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error dwollaErrorMessageWithDefaultMessage:@"Unknown error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }];
}

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 54;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 67, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"DWOTransactionCell" bundle:nil] forCellReuseIdentifier:@"Money Request Cell"];
    self.tableView.dataSource = self.moneyRequestDataSource;
    self.tableView.delegate = self.moneyRequestDataSource;
    self.moneyRequestDataSource.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor dwollaOrangeColor];
    [refreshControl addTarget:self action:@selector(refreshValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    self.refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_once(&_onceToken, ^{
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
        [self.refreshControl beginRefreshing];
        [self.moneyRequestDataSource refreshData];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:REQUEST_SEGUE]) {
        DWORequestViewController *requestViewController = (DWORequestViewController *)segue.destinationViewController;
        requestViewController.moneyRequest = (DWOMoneyRequest *)sender;
        requestViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:SEND_SEGUE]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        DWOTransferViewController *sendViewController = (DWOTransferViewController *)navController.topViewController;
        sendViewController.delegate = self;
        DWOMoneyRequest *moneyRequest = (DWOMoneyRequest *)sender;
        sendViewController.transferStrategy = [moneyRequest convertToFulfillMoneyRequestStrategy];
    }
}

#pragma mark - DWOSend2ViewControllerDelegate

- (void)sendViewController:(DWOTransferViewController *)sendViewController cancelled:(DWOSendRequest *)request {
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendViewController:(DWOTransferViewController *)sendViewController sent:(DWOSendRequest *)sent response:(DWOSendResponse *)response {
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToViewController:self animated:YES];
    [self.moneyRequestDataSource refreshData];
}

#pragma mark - DWORequestViewControllerDelegate

- (void)fulfillRequestViewController:(DWORequestViewController *)requestViewController {
    [self fulfillRequest:requestViewController.moneyRequest];
}

- (void)declineRequestViewController:(DWORequestViewController *)requestViewController {
    [self declineMoneyRequest:requestViewController.moneyRequest];
}

#pragma mark - DWOMoneyRequestsDataSourceDelegate

- (void)moneyRequestsDataSource:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource didSelectRequest:(DWOMoneyRequest *)moneyRequest {
    [self performSegueWithIdentifier:REQUEST_SEGUE sender:moneyRequest];
}

- (void)moneyRequestsDataSourceDidBeginLoading:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource {
    [self.refreshControl beginRefreshing];
}

- (void)moneyRequestsDataSourceDidFinishLoading:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource error:(NSError *)error {
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (BOOL)moneyRequestsDataSource:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource shouldDisplayMoneyRequest:(DWOMoneyRequest *)moneyRequest {
    return [moneyRequest.destination.accountId isEqualToString:self.user.accountId];
}

#pragma mark - UIRefreshControl

- (IBAction)refreshValueChanged:(UIRefreshControl *)sender {
    if (sender.isRefreshing) {
        [self.moneyRequestDataSource refreshData];
    }
}

@end
