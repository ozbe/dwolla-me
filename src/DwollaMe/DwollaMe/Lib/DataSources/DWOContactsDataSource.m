//
//  ContactsDataSource.m
//  DwollaMe
//
//  Created by Josh Aaseby on 1/28/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOContactsDataSource.h"
// data access
#import "DWOContactsClient.h"
// views
#import "DWOContactCell.h"
// models
#import "DWOContactSearchRequest.h"
#import "DWOUserSearchFilterOption.h"
// categories
#import "NSString+Dwolla.h"
// constants
#import "DWORestApiConstants.h"

@interface DWOContactsDataSource ()
@property (nonatomic, strong) DWOContactsClient * contactsClient;
@property (nonatomic, strong) NSOperationQueue *contactsQueue;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) DWOContactSearchRequest *request;
@end

@implementation DWOContactsDataSource

#define DEFAULT_LIMIT 25
#define CELL_IDENTIFIER @"Contact Cell"

#pragma mark - Properties

- (DWOContactsClient *)contactsClient {
    if (!_contactsClient) {
        _contactsClient = [[DWOContactsClient alloc] init];
    }
    return _contactsClient;
}

#warning gots to go
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 54;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 67, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"DWOContactCell" bundle:nil] forCellReuseIdentifier:CELL_IDENTIFIER];
}

- (NSString *)searchText {
    return self.request.term;
}

- (void)setSearchText:(NSString *)searchText {
    if (self.searchText != searchText) {
        self.request.term = searchText;
        [self fetchAndSetContacts];
    }
}

- (NSOperationQueue *)contactsQueue {
    if (!_contactsQueue) {
        _contactsQueue = [[NSOperationQueue alloc] init];
        _contactsQueue.name = @"Contacts Queue";
        _contactsQueue.maxConcurrentOperationCount = 1;
    }
    return _contactsQueue;
}

- (NSArray *)contacts {
    if (!_contacts) {
        _contacts = [NSArray array];
    }
    return _contacts;
}

- (NSNumber *)resultsLimit {
    if (!self.request.limit) {
        self.request.limit = [NSNumber numberWithInt:DEFAULT_LIMIT];
    }
    return self.request.limit;
}

- (void)setResultsLimit:(NSNumber *)resultsLimit {
    self.request.limit = resultsLimit;
}

- (DWOUserSearchFilterOptions *)filterOptions {
    return self.request.options;
}

- (void)setFilterOptions:(DWOUserSearchFilterOptions *)filterOptions {
    self.request.options = filterOptions;
}

- (DWOContactSearchRequest *)request {
    if (!_request) {
        _request = [[DWOContactSearchRequest alloc] init];
    }
    return _request;
}

#pragma mark - Public

- (void)refreshData {
    [self fetchAndSetContacts];
}

- (void)clearData {
    self.searchText = nil;
}

- (DWOContact *)contactAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row < self.contacts.count) ? [self.contacts objectAtIndex:indexPath.row] : nil;
}

#pragma mark - Private

- (void)fetchAndSetContacts {
    [self.contactsQueue cancelAllOperations];
    
    __weak DWOContactsDataSource *self_weak = self;
    
    [self notifyDelegateDidBeginSearching];
    
    [self.contactsQueue addOperationWithBlock:^{
#warning don't just swallow this error
        NSError *error;
        NSArray *contacts = [self_weak fetchContactsOrReturnError:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self_weak setContactsAndNotifyDelegate:contacts];
        }];
    }];
}

- (void)notifyDelegateDidBeginSearching {
    if ([self.delegate respondsToSelector:@selector(contactsDataSourceDidBeginSearching:)]) {
        [self.delegate contactsDataSourceDidBeginSearching:self];
    }
}

- (NSArray *)fetchContactsOrReturnError:(NSError **)error {
    if (!self.searchText.length) {
        return [NSArray array];
    }
    
    NSArray *contacts = [self.contactsClient searchContacts:self.request error:error];
    
    if (!*error && !contacts.count) {
        contacts = [self fetchNonDwollaContacts];
    }
    
    return contacts;
}

- (NSArray *)fetchNonDwollaContacts {
    NSMutableArray *contacts = [NSMutableArray array];
    
    if ([self contactTypeEnabled:kDWOContactTypeEmail] && [self.request.term isValidEmail]) {
        DWOContact *contact = [[DWOContact alloc] init];
        contact.name = self.request.term;
        contact.contactId = self.request.term;
        contact.type = kDWOContactTypeEmail;
        [contacts addObject:contact];
    }
    
    if ([self contactTypeEnabled:kDWOContactTypePhone] && [self.request.term isValidPhone]) {
        DWOContact *contact = [[DWOContact alloc] init];
        contact.name = self.request.term;
        contact.contactId = self.request.term;
        contact.type = kDWOContactTypePhone;
        [contacts addObject:contact];
    }
    
    if ([self contactTypeEnabled:kDWOContactTypeDwolla] && [self.request.term isValidDwollaId]) {
        DWOContact *contact = [[DWOContact alloc] init];
        contact.name = self.request.term;
        contact.contactId = self.request.term;
        contact.type = kDWOContactTypeDwolla;
        [contacts addObject:contact];
    }
    
    return contacts;
}

- (BOOL)contactTypeEnabled:(NSString *)contactType {
    for (DWOUserSearchFilterOption *option in self.request.options.idTypes) {
        if ([option.name caseInsensitiveCompare:contactType] == NSOrderedSame) {
            return option.enabled;
        }
    }
    
    return NO;
}

- (void)setContactsAndNotifyDelegate:(NSArray *)contacts {
    self.contacts = contacts;
    [self notifyDelegateDidFinishSearching];
}

- (void)notifyDelegateDidFinishSearching {
    if ([self.delegate respondsToSelector:@selector(contactsDataSourceDidFinishSearching:)]) {
        [self.delegate contactsDataSourceDidFinishSearching:self];
    }
}

- (void)notifyDelegateDidSelectContact:(DWOContact *)contact {
    if ([self.delegate respondsToSelector:@selector(contactsDataSource:didSelectContact:)]) {
        [self.delegate contactsDataSource:self didSelectContact:contact];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self notifyDelegateDidSelectContact:[self contactAtIndexPath:indexPath]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DWOContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    cell.contact = [self.contacts objectAtIndex:indexPath.row];
    return cell;
}

@end
