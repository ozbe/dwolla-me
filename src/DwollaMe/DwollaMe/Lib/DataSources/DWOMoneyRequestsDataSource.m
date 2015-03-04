//
//  DWOPendingRequestsDataSource.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/22/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOMoneyRequestsDataSource.h"
// data access
#import "DWOMoneyRequestsClient.h"
// views
#import "DWOTransactionCell.h"

@interface DWOMoneyRequestsDataSource ()
@property (nonatomic, copy) void (^configureCellBlock)(DWOTransactionCell *cell, DWOMoneyRequest *moneyRequest);
@property (nonatomic, assign) NSUInteger skip;
@property (nonatomic, strong) NSOperationQueue *moneyRequestsQueue;
@property (nonatomic, strong) NSMutableArray *moneyRequests;
@property (nonatomic, assign) BOOL stopInfinite;
@property (nonatomic, strong) DWOMoneyRequestsClient *moneyRequestsClient;
@end

@implementation DWOMoneyRequestsDataSource

#pragma mark - Static

#define CELL_IDENTIFIER @"Money Request Cell"

#pragma mark - Properties

- (void)setTableView:(UITableView *)tableView {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (NSOperationQueue *)moneyRequestsQueue {
    if (!_moneyRequestsQueue) {
        _moneyRequestsQueue = [[NSOperationQueue alloc] init];
        _moneyRequestsQueue.name = @"Money Requests Queue";
        _moneyRequestsQueue.maxConcurrentOperationCount = 1;
    }
    return _moneyRequestsQueue;
}

- (NSMutableArray *)moneyRequests {
    if (!_moneyRequests) {
        _moneyRequests = [NSMutableArray array];
    }
    return _moneyRequests;
}

- (DWOMoneyRequestsClient *)moneyRequestsClient {
    if (!_moneyRequestsClient) {
        _moneyRequestsClient = [[DWOMoneyRequestsClient alloc] init];
    }
    return _moneyRequestsClient;
}

#pragma mark - Initializers

- (instancetype)initWithConfigureCellBlock:(void(^)(DWOTransactionCell *cell, DWOMoneyRequest *moneyRequest))configureCellBlock {
    self = [super init];
    
    if (self) {
        self.configureCellBlock = configureCellBlock;
    }
    
    return self;
}

#pragma mark - Public

- (void)refreshData {
    [self clearData];
    [self fetchAndAppendMoneyRequests];
}

- (void)clearData {
    [self.moneyRequestsQueue cancelAllOperations];
    self.moneyRequests = nil;
    self.stopInfinite = NO;
    self.skip = 0;
}

- (DWOMoneyRequest *)moneyRequestAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < self.moneyRequests.count) ? [self.moneyRequests objectAtIndex:indexPath.row] : nil;
}

#pragma mark - Private

- (void)fetchAndAppendMoneyRequests {
    __weak DWOMoneyRequestsDataSource *self_weak = self;
    
    [self notifyDelegateDidBeginLoading];
    
    DWOMoneyRequestsRequest *request = [self createRequest];
    self.skip += self.limit;
    
    [self.moneyRequestsQueue addOperationWithBlock:^{
        NSError *error;
        NSArray *moneyRequests = [self_weak fetchMoneyRequests:request error:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self_weak appendMoneyRequests:moneyRequests error:error];
        }];
    }];
}

- (DWOMoneyRequestsRequest *)createRequest {
    DWOMoneyRequestsRequest *request = [[DWOMoneyRequestsRequest alloc] init];
    request.limit = [NSNumber numberWithInteger:self.limit];
    request.skip = [NSNumber numberWithInteger:self.skip];
    return request;
}

- (NSArray *)fetchMoneyRequests:(DWOMoneyRequestsRequest *)request error:(NSError **)error {
    return [self.moneyRequestsClient moneyRequests:request error:error];
}

- (void)appendMoneyRequests:(NSArray *)moneyRequests error:(NSError *)error {
    if (moneyRequests) {
        [self appendMoneyRequests:moneyRequests];
        self.stopInfinite = moneyRequests.count < self.limit;
    }
    
    [self notifyDelegateDidFinishLoading:error];
}

- (void)appendMoneyRequests:(NSArray *)moneyRequests {
    for (DWOMoneyRequest *moneyRequest in moneyRequests) {
        if ([self shouldDisplayMoneyRequest:moneyRequest]) {
            [self.moneyRequests addObject:moneyRequest];
        }
    }
}

- (BOOL)shouldDisplayMoneyRequest:(DWOMoneyRequest *)moneyRequest {
    return ![self.delegate respondsToSelector:@selector(moneyRequestsDataSource:shouldDisplayMoneyRequest:)] || [self.delegate moneyRequestsDataSource:self shouldDisplayMoneyRequest:moneyRequest];
}

- (void)notifyDelegateDidBeginLoading {
    if ([self.delegate respondsToSelector:@selector(moneyRequestsDataSourceDidBeginLoading:)]) {
        [self.delegate moneyRequestsDataSourceDidBeginLoading:self];
    }
}

- (void)notifyDelegateDidFinishLoading:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(moneyRequestsDataSourceDidFinishLoading:error:)]) {
        [self.delegate moneyRequestsDataSourceDidFinishLoading:self error:error];
    }
}

- (void)notifyDelegateDidSelectMoneyRequest:(DWOMoneyRequest *)moneyRequest {
    if ([self.delegate respondsToSelector:@selector(moneyRequestsDataSource:didSelectRequest:)]) {
        [self.delegate moneyRequestsDataSource:self didSelectRequest:moneyRequest];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DWOMoneyRequest *moneyRequest = [self moneyRequestAtIndexPath:indexPath];
    [self notifyDelegateDidSelectMoneyRequest:moneyRequest];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.moneyRequests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWOTransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    self.configureCellBlock(cell, [self moneyRequestAtIndexPath:indexPath]);
    [cell setCellHeight:cell.frame.size.height];
    cell.containingTableView = tableView;
    return cell;
}

@end
