//
//  SearchFilterViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/8/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOSearchFilterViewController.h"
// vendors
#import "TestFlight.h"

@implementation DWOSearchFilterViewController

#pragma mark - Events

- (IBAction)done:(id)sender {
    [self.delegate dismissSearchFilterViewController:self];
}

#pragma mark - Private

- (NSArray *)filterOptionsForSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.filterOptions.idTypes;
        default:
            return nil;
    }
}

- (DWOUserSearchFilterOption *)getFilterOptionForPath:(NSIndexPath *)indexPath {
    return [[self filterOptionsForSection:indexPath.section] objectAtIndex:indexPath.row];
}

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [TestFlight passCheckpoint:@"Filter transactions"];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self filterOptionsForSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterOption"];
    
    DWOUserSearchFilterOption *filterOption = [self getFilterOptionForPath:indexPath];
    cell.textLabel.text = filterOption.name;
    cell.accessoryType = filterOption.enabled ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DWOUserSearchFilterOption *filterOption = [self getFilterOptionForPath:indexPath];
    filterOption.enabled = !filterOption.enabled;
    
    if ([self.delegate respondsToSelector:@selector(searchFilterViewController:searchFilterOption:enabled:)]) {
        [self.delegate searchFilterViewController:self searchFilterOption:filterOption enabled:filterOption.enabled];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
