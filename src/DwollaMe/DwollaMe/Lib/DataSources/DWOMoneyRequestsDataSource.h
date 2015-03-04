//
//  DWOPendingRequestsDataSource.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/22/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// models
#import "DWOMoneyRequest.h"
// views
#import "DWOTransactionCell.h"

@protocol DWOMoneyRequestsDataSourceDelegate;

@interface DWOMoneyRequestsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id<DWOMoneyRequestsDataSourceDelegate> delegate;
@property (nonatomic, assign) NSUInteger limit;

- (instancetype)initWithConfigureCellBlock:(void(^)(DWOTransactionCell *cell, DWOMoneyRequest *moneyRequest))configureCellBlock;

- (void)refreshData;
- (void)clearData;
- (DWOMoneyRequest *)moneyRequestAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DWOMoneyRequestsDataSourceDelegate <NSObject>

@optional

- (void)moneyRequestsDataSourceDidBeginLoading:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource;
- (void)moneyRequestsDataSourceDidFinishLoading:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource error:(NSError *)error;
- (void)moneyRequestsDataSource:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource didSelectRequest:(DWOMoneyRequest *)moneyRequest;
- (BOOL)moneyRequestsDataSource:(DWOMoneyRequestsDataSource *)moneyRequestsDataSource shouldDisplayMoneyRequest:(DWOMoneyRequest *)moneyRequest;

@end
