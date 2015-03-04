//
//  DWOActivityViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOActivityViewController.h"
// data access
#import "DWOTransactionsClient.h"
#import "DWOMoneyRequestsClient.h"
// view controllers
#import "DWOTransactionFilterViewController.h"
#import "DWOTransactionViewController.h"
#import "DWOTransferViewController.h"
// categories
#import "UIColor+Dwolla.h"
#import "DWOTransaction+Dwolla.h"
#import "DWOTransactionCell+DWOTransaction.h"

@interface DWOActivityViewController () <DWOTransactionFilterViewControllerDelegate, DWOTransferViewControllerDelegate, SWTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *requestsBarButtonItem;
@property (nonatomic, strong) DWOTransactionsClient *transactionsClient;
@property (nonatomic, strong) DWOMoneyRequestsClient *requestsClient;
@property (nonatomic, strong) NSArray *transactions;
@property (nonatomic, strong) NSArray *requests;
@property (nonatomic) BOOL isReloadTransactionsPending;
@property (nonatomic) BOOL stopInfinite;
@property (nonatomic, strong) DWOTransactionsRequest *transactionsRequest;
@property (nonatomic, assign) NSUInteger page;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *infiniteActivityIndicator;
@property (nonatomic) BOOL isFirstAppearance;
@end

@implementation DWOActivityViewController

#pragma mark - Static

static int kTransactionsLimit = 25;
static int kRequestsLimit = 26;

#pragma mark - Properties

@synthesize transactions = _transactions;
@synthesize requests = _requests;

- (DWOTransactionsClient *)transactionsClient {
    if (!_transactionsClient) {
        _transactionsClient = [[DWOTransactionsClient alloc] init];
    }
    
    return _transactionsClient;
}

- (DWOMoneyRequestsClient *)requestsClient {
    if (!_requestsClient) {
        _requestsClient = [[DWOMoneyRequestsClient alloc] init];
    }
    
    return _requestsClient;
}

- (NSArray *)transactions {
    if (!_transactions) {
        _transactions = [NSArray array];
    }
    
    return _transactions;
}

- (void)setTransactions:(NSArray *)transactions {
    _transactions = transactions;
    
    if (self.view.window) {
        [self.tableView reloadData];
    }
}

- (NSArray *)requests {
    if (!_requests) {
        _requests = [NSArray array];
    }
    
    return _requests;
}

- (DWOTransactionsRequest *)transactionsRequest {
    if (!_transactionsRequest) {
        _transactionsRequest = [[DWOTransactionsRequest alloc] init];
        self.transactionsRequest.limit = [NSNumber numberWithInt:kTransactionsLimit];
        
    }
    return _transactionsRequest;
}

- (void)setPage:(NSUInteger)page {
    _page = page;
    int skip = (int)self.page * [self.transactionsRequest.limit intValue];
    self.transactionsRequest.skip = [NSNumber numberWithInt:skip];
}

- (void)setRequests:(NSArray *)requests {
    _requests = requests;
    
    if (self.requests.count > 0) {
        self.requestsBarButtonItem.enabled = YES;
        NSInteger displayCount = (self.requests.count == kRequestsLimit) ? self.requests.count - 1 : self.requests.count;
        NSString *suffix = (self.requests.count == kRequestsLimit) ? @"+" : @"";
        
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i%@", displayCount, suffix];
    } else {
        self.requestsBarButtonItem.enabled = NO;
        self.navigationController.tabBarItem.badgeValue = nil;;
    }
}

#pragma mark - Private

- (void)loadTransactions {
    dispatch_queue_t transactionsQueue = dispatch_queue_create("Activity Transactions", NULL);
    dispatch_async(transactionsQueue, ^{
        NSError *error;
        NSArray *transactions = [self.transactionsClient transactions:self.transactionsRequest error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (transactions.count) {
                self.transactions = [self.transactions arrayByAddingObjectsFromArray:transactions];
            } else {
                self.stopInfinite = YES;
            }
            
            [self.refreshControl endRefreshing];
            [self.infiniteActivityIndicator stopAnimating];
        });
    });
}

- (void)loadRequests {
    /*
    dispatch_queue_t requestsQueue = dispatch_queue_create("Requests", NULL);
    dispatch_async(requestsQueue, ^{
        NSError *error;
        DWOMoneyRequestsRequest *request = [[DWOMoneyRequestsRequest alloc] init];
        request.limit = [NSNumber numberWithInt:26];
        
        NSArray *requests = [self.requestsClient moneyRequests:request error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.requests = requests;
        });
    });
    */
}

- (void)refreshData {
    [self refreshTransactions];
    [self loadRequests];
}

- (void)refreshTransactions {
    [self.refreshControl beginRefreshing];
    self.transactions = nil;
    self.page = 0;
    self.stopInfinite = NO;
    [self loadTransactions];
}

- (void)adjustOffsetToShowRefresh:(void (^)(BOOL finished))handler {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    } completion:handler];
}

- (void)authNotification:(NSNotification *)notification {
    self.isFirstAppearance = NO;
    [self loadTransactions];
}

- (DWOTransaction *)transactionForSwipeCell:(SWTableViewCell *)cell {
    NSIndexPath *indexPath = [cell.containingTableView indexPathForCell:cell];
    return [self transactionForIndexPath:indexPath];
}

- (DWOTransaction *)transactionForIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < self.transactions.count) ? [self.transactions objectAtIndex:indexPath.row] : nil;
}

#pragma mark - Events

- (IBAction)unwindToActivity:(UIStoryboardSegue *)unwindSegue {
    self.tableView.editing = NO;
    if (self.isReloadTransactionsPending) {
        self.isReloadTransactionsPending = NO;
        [self adjustOffsetToShowRefresh:^(BOOL finished) {
            [self refreshTransactions];
        }];
    }
}

#pragma mark - Initializers

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.isFirstAppearance = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authNotification:) name:@"auth" object:nil];
    }
    
    return self;
}

#pragma mark - Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = 54;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 67, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"DWOTransactionCell" bundle:nil] forCellReuseIdentifier:@"Transaction Cell"];
    
    [self loadRequests];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_transactions) {
        //[self.tableView reloadData];
    } else if ((self.isFirstAppearance && self.tableView.contentOffset.y == 0)) {
        self.isFirstAppearance = NO;
        [self adjustOffsetToShowRefresh:^(BOOL finished) {
            [self.refreshControl beginRefreshing];
            [self loadTransactions];
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"auth" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Filter"]) {
        UINavigationController *navController = segue.destinationViewController;
        DWOTransactionFilterViewController *filter = (DWOTransactionFilterViewController *)navController.topViewController;
        filter.delegate = self;
        filter.types = self.transactionsRequest.types;
    } else if ([segue.identifier isEqualToString:@"Transaction"]) {
        DWOTransactionViewController *transactionViewController = segue.destinationViewController;
        transactionViewController.transaction = (DWOTransaction *)sender;
    } else if ([segue.identifier isEqualToString:@"Send"] && [sender isKindOfClass:[DWOTransaction class]]) {
        DWOTransaction *transaction = (DWOTransaction *)sender;
        UINavigationController *navController = segue.destinationViewController;
        DWOTransferViewController *sendViewController = (DWOTransferViewController *)navController.topViewController;
        sendViewController.delegate = self;
        
        sendViewController.transferStrategy = [transaction convertToSendStrategy];
    }
}

#pragma mark - DWOSendViewController

- (void)sendViewController:(DWOTransferViewController *)sendViewController cancelled:(DWOSendRequest *)request {
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
    self.tableView.editing = NO;
}

- (void)sendViewController:(DWOTransferViewController *)sendViewController sent:(DWOSendRequest *)sent response:(DWOSendResponse *)response {
    [self refreshTransactions];
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DWOTransactionFilterViewControllerDelegate

- (void)transactionFilterViewController:(DWOTransactionFilterViewController *)transactionFilter transactionFilterOption:(DWOBoolSearchOption *)searchOption enabled:(BOOL)enabled {
    self.isReloadTransactionsPending = YES;
}

#pragma mark - SWTableViewCellDelegate

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    DWOTransaction *transaction = [self transactionForSwipeCell:cell];
    return [transaction isTransfer] && state != kCellStateLeft;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [self performSegueWithIdentifier:@"Send" sender:[self transactionForSwipeCell:cell]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Transaction Cell";
    DWOTransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.transaction = [self.transactions objectAtIndex:indexPath.row];
    [cell setCellHeight:cell.frame.size.height];
    
    __weak DWOTransactionCell *cell_weak = cell;
    
    [cell setAppearanceWithBlock:^{
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] title:@""];
        //[rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor dwollaGrayColor] title:@"Request"];
        [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor dwollaOrangeColor] title:@"Send"];
        
        cell_weak.leftUtilityButtons = leftUtilityButtons;
        cell_weak.rightUtilityButtons = rightUtilityButtons;
        cell_weak.delegate = self;
        cell_weak.containingTableView = self.tableView;
    } force:NO];
    
    if (!self.stopInfinite && indexPath.row + 1 == self.transactions.count) {
        self.page = self.page + 1;
        [self.infiniteActivityIndicator startAnimating];
        [self loadTransactions];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"Transaction" sender:[self.transactions objectAtIndex:indexPath.row]];
}

#pragma mark - UIRefreshViewDelegate

- (IBAction)refreshValueChanged:(UIRefreshControl *)sender {
    if (sender.isRefreshing) {
        [self refreshData];
    }
}

@end
