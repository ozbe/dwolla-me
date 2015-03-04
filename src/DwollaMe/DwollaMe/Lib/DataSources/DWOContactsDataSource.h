//
//  ContactsDataSource.h
//  DwollaMe
//
//  Created by Josh Aaseby on 1/28/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// models
#import "DWOContact.h"
#import "DWOUserSearchFilterOptions.h"

@protocol DWOContactsDataSourceDelegate;

@interface DWOContactsDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id<DWOContactsDataSourceDelegate> delegate;
@property (nonatomic, strong) NSNumber *resultsLimit;
@property (nonatomic, strong) DWOUserSearchFilterOptions *filterOptions;

- (void)refreshData;
- (void)clearData;
- (DWOContact *)contactAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DWOContactsDataSourceDelegate <NSObject>

@optional

- (void)contactsDataSourceDidBeginSearching:(DWOContactsDataSource *)contactsDataSource;
- (void)contactsDataSourceDidFinishSearching:(DWOContactsDataSource *)contactsDataSource;
//- (void)contactsDataSource:(ContactsDataSource *)contactsDataSource didFinishSearchingWithError:(NSError *)error;
- (void)contactsDataSource:(DWOContactsDataSource *)contactsDataSource didSelectContact:(DWOContact *)contact;

@end
