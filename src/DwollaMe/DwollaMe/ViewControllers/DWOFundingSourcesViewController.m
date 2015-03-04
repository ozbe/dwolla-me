//
//  FundsViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/15/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOFundingSourcesViewController.h"
// data access
#import "DWOFundingSourcesClient.h"
// models
#import "DWOFundingSource.h"
#import "DWODepositToBalanceFundStrategy.h"
#import "DWOWithdrawFromBalanceFundStategy.h"
// view controllers
#import "DWOFundViewController.h"
// views
#import "DWOBalancedSourceCell.h"
// categories
#import "UIColor+Dwolla.h"
#import "DWOFundingSource+Dwolla.h"

@interface DWOFundingSourcesViewController () <DWOFundViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@property (nonatomic, strong) DWOFundingSourcesClient *fundsRepository;
@property (nonatomic, strong) NSArray *realtimeFundingSources;
@property (nonatomic, strong) NSArray *bankFundingSources;
@property (nonatomic, strong, readonly) NSSet *realtimeIds;
@property (nonatomic, assign) BOOL isPendingRefresh;
@property (nonatomic, strong) NSMutableDictionary *fundingSourceIdToBalance;
@end

@implementation DWOFundingSourcesViewController

#define REALTIME_SECTION_INDEX 0
#define BANK_SECTION_INDEX 1
#define REALTIME_SECTION_HEADER @"Dwolla"
#define BANK_SECTION_HEADER @"Banks"

static NSString *CASH_ID = @"Balance";
static NSString *CREDIT_ID = @"Credit";

#pragma mark - Properties

- (NSArray *)realtimeFundingSources {
    if (!_realtimeFundingSources) {
        _realtimeFundingSources = [NSArray array];
    }
    
    return _realtimeFundingSources;
}

- (NSArray *)bankFundingSources {
    if (!_bankFundingSources) {
        _bankFundingSources = [NSArray array];
    }
    
    return _bankFundingSources;
}

- (DWOFundingSourcesClient *)fundsRepository {
    if (!_fundsRepository) {
        _fundsRepository = [[DWOFundingSourcesClient alloc] init];
    }
    
    return _fundsRepository;
}

- (NSSet *)realtimeIds {
    return [NSSet setWithObjects:CASH_ID, CREDIT_ID, nil];
}

- (NSMutableDictionary *)fundingSourceIdToBlance {
    if (!_fundingSourceIdToBalance) {
        _fundingSourceIdToBalance = [NSMutableDictionary dictionary];
    }
    return _fundingSourceIdToBalance;
}

#pragma mark - Private Methods

- (void)loadFundingSources {
    self.realtimeFundingSources = nil;
    self.bankFundingSources = nil;
    self.fundingSourceIdToBalance = nil;
    
    dispatch_queue_t fundingSourcesQueue = dispatch_queue_create("Funding Sources", NULL);
    dispatch_async(fundingSourcesQueue, ^{
        NSError *error;
        NSArray *fundingSources = [self.fundsRepository fundingSourcesOrError:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self separateAndSetFundingSources:fundingSources];
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)separateAndSetFundingSources:(NSArray *)fundingSources {
    NSMutableArray *realtimeFundingSources = [NSMutableArray array];
    NSMutableArray *bankFundingSources = [NSMutableArray array];
    
    for (DWOFundingSource *fundingSource in fundingSources) {
        if ([self.realtimeIds containsObject:fundingSource.fundingSourceId]) {
            [realtimeFundingSources addObject:fundingSource];
        } else {
            [bankFundingSources addObject:fundingSource];
        }
    }
    
    self.bankFundingSources = bankFundingSources;
    self.realtimeFundingSources = realtimeFundingSources;
    
    if (self.view.window) {
        [self.tableView reloadData];
    }
}

- (DWOFundingSource *)fundingSourceAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case REALTIME_SECTION_INDEX:
            return [self.realtimeFundingSources objectAtIndex:indexPath.row];
        case BANK_SECTION_INDEX:
            return [self.bankFundingSources objectAtIndex:indexPath.row];
        default:
            return nil;
    }
}

- (BOOL)isBalancedFundingSource:(DWOFundingSource *)fundingSource {
    return ![fundingSource.processingType isEqualToString:@"ACH"];
}

- (NSNumber *)balanceForFundingSource:(DWOFundingSource *)fundingSource {
    return [self.fundingSourceIdToBlance objectForKey:fundingSource.fundingSourceId];
}

- (void)authNotification:(NSNotification *)notification {
    self.isPendingRefresh = NO;
    [self loadFundingSources];
}

- (DWOFundingSource *)fundingSourceFromTableSubview:(UIView *)view {
    CGPoint buttonPosition = [view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    return [self fundingSourceAtIndexPath:indexPath];
}

- (void)adjustOffsetToShowRefresh:(void (^)(BOOL finished))handler {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    } completion:handler];
}

#pragma mark - Events

- (IBAction)withdraw:(UIView *)sender {
    DWOFundingSource *fundingSource = [self fundingSourceFromTableSubview:sender];
    [self performSegueWithIdentifier:@"Withdraw" sender:fundingSource];
}

- (IBAction)deposit:(UIView *)sender {
    DWOFundingSource *fundingSource = [self fundingSourceFromTableSubview:sender];
    [self performSegueWithIdentifier:@"Deposit" sender:fundingSource];
}

- (IBAction)unwindToFunds:(UIStoryboardSegue *)unwindSegue {
}

#pragma mark - Overrides

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.isPendingRefresh = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authNotification:) name:@"auth" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isPendingRefresh) {
        self.isPendingRefresh = NO;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
        } completion:^(BOOL finished){
            [self.refreshControl beginRefreshing];
            [self loadFundingSources];
        }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"auth" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DWOFundingSource *fundingSource = (DWOFundingSource *)sender;
    
    if (![fundingSource isBalance]) {
        return;
    }
    
    DWOBalanceFundStrategy *balanceFundStrategy = nil;
    
    if ([segue.identifier isEqualToString:@"Deposit"]) {
        balanceFundStrategy = [[DWODepositToBalanceFundStrategy alloc] init];
    } else if ([segue.identifier isEqualToString:@"Withdraw"]) {
        balanceFundStrategy = [[DWOWithdrawFromBalanceFundStategy alloc] init];
    }
    
    if (balanceFundStrategy) {
        UINavigationController *navController = segue.destinationViewController;
        DWOFundViewController *fundViewController = (DWOFundViewController *)navController.topViewController;
        fundViewController.title = fundingSource.name;
        fundViewController.delegate = self;
        fundViewController.fundStrategy = balanceFundStrategy;
    }
}

#pragma mark - DWOFundViewControllerDelegate

- (void)fundViewController:(DWOFundViewController *)fundViewController didSubmitRequest:(DWOFundRequest *)request transaction:(DWOTransaction *)transaction {
    self.isPendingRefresh = YES;
    [fundViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)fundViewController:(DWOFundViewController *)fundViewController didSubmitRequest:(DWOFundRequest *)request error:(NSError *)error {
}

- (void)didCancelFundViewController:(DWOFundViewController *)fundViewController {
    [fundViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWOFundingSource *fundingSource = [self fundingSourceAtIndexPath:indexPath];
    return [fundingSource isBalancedFundingSource] ? 75 : 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.bankFundingSources.count > 0 ? 2 : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case REALTIME_SECTION_INDEX:
            return REALTIME_SECTION_HEADER;
        case BANK_SECTION_INDEX:
            return BANK_SECTION_HEADER;
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case REALTIME_SECTION_INDEX:
            return self.realtimeFundingSources.count;
        case BANK_SECTION_INDEX:
            return self.bankFundingSources.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *BalanceCellIdentifier = @"Balance Source Cell";
    static NSString *NoBalanceCellIdentifier = @"Source Cell";
    
    DWOFundingSource *fundingSource = [self fundingSourceAtIndexPath:indexPath];
    DWOBalancedSourceCell *cell = nil;
    
    if ([self isBalancedFundingSource:fundingSource]) {
        cell = [tableView dequeueReusableCellWithIdentifier:BalanceCellIdentifier forIndexPath:indexPath];
        cell.fundingSource = fundingSource;
        cell.fundingSourceBalance = nil;
        
        if ([self balanceForFundingSource:fundingSource]) {
            cell.fundingSourceBalance = [self balanceForFundingSource:fundingSource];
        } else {
            cell.detailTextLabel.text = nil;
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.color = [UIColor dwollaOrangeColor];
            [activityIndicatorView startAnimating];
            cell.accessoryView = activityIndicatorView;
            
            dispatch_queue_t balanceQueue = dispatch_queue_create("Balance Queue", NULL);
            dispatch_async(balanceQueue, ^{
                NSError *error;
                [self.fundingSourceIdToBlance setValue:[self.fundsRepository balanceForFundingSourceId:fundingSource.fundingSourceId error:&error] forKey:fundingSource.fundingSourceId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (cell.accessoryView) {
                        cell.accessoryView = nil;
                        cell.fundingSourceBalance = [self balanceForFundingSource:fundingSource];
                    }
                });
            });
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:NoBalanceCellIdentifier forIndexPath:indexPath];
        cell.fundingSource = fundingSource;
        cell.fundingSourceBalance = nil;
    }
    
    return cell;
}

#pragma mark - UIRefreshControl

- (IBAction)refreshValueChanged:(UIRefreshControl *)sender {
    if (sender.isRefreshing) {
        [self loadFundingSources];
    }
}

@end
