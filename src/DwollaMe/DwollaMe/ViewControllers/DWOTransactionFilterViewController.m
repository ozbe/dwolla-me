//
//  DWOTransactionFilterViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransactionFilterViewController.h"
// vendors
#import "TestFlight.h"

@interface DWOTransactionFilterViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetBarButtonItem;
@property (strong, nonatomic) NSIndexPath *datePickerCellIndexPath;
@end

@implementation DWOTransactionFilterViewController

#define TYPE_SECTION_INDEX 0
#define DATE_SECTION_INDEX 1

#pragma mark - Properties

- (NSArray *)types {
    if (!_types) {
        _types = [NSArray array];
    }
    return _types;
}

#pragma mark - Private

- (BOOL)isDatePickerCellIndexPath:(NSIndexPath *)indexPath {
    return self.datePickerCellIndexPath && self.datePickerCellIndexPath.section == indexPath.section && self.datePickerCellIndexPath.row == indexPath.row;
}

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TestFlight passCheckpoint:@"Filter transactions"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case TYPE_SECTION_INDEX:
            return self.types.count;
        case DATE_SECTION_INDEX:
            return (self.datePickerCellIndexPath) ? 3 : 2;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDatePickerCellIndexPath:indexPath]) {
        return 163;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == DATE_SECTION_INDEX && ![self isDatePickerCellIndexPath:indexPath]) {
        self.datePickerCellIndexPath = [NSIndexPath indexPathForRow:MIN(2, indexPath.row + 1) inSection:indexPath.section];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:DATE_SECTION_INDEX] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        DWOBoolSearchOption *searchOption = [self.types objectAtIndex:indexPath.row];
        searchOption.enabled = !searchOption.enabled;
        
        if ([self.delegate respondsToSelector:@selector(transactionFilterViewController:transactionFilterOption:enabled:)]) {
            [self.delegate transactionFilterViewController:self transactionFilterOption:searchOption enabled:searchOption.enabled];
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TYPE_SECTION_INDEX) {
        static NSString *CellIdentifier = @"Type Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        DWOBoolSearchOption * searchOption = [self.types objectAtIndex:indexPath.row];
        
        cell.textLabel.text = searchOption.name;
        cell.accessoryType = searchOption.enabled ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        return cell;
    } else if ([self isDatePickerCellIndexPath:indexPath]) {
        static NSString *CellIdentifier = @"Date Picker Cell";
        return [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    } else {
        static NSString *CellIdentifier = @"Date Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = (indexPath.row == 0) ? @"From" : @"To";
        cell.detailTextLabel.text = @"Anytime";
        
        return cell;
    }
}

@end
