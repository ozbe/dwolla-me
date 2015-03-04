//
//  DWORequestViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/25/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWORequestViewController.h"
// lib
#import "DWOMoneyRequestsDataSource.h"
// categories
#import "NSDate+Dwolla.h"
#import "NSNumber+Dwolla.h"

@interface DWORequestViewController () <UITableViewDataSource, UIAlertViewDelegate>
@end

@implementation DWORequestViewController

#pragma mark - Static

#define DETAIL_NAME_ROW_INDEX 0
#define DETAIL_AMOUNT_ROW_INDEX 1
#define DETAIL_DATE_ROW_INDEX 2
#define DETAIL_NOTES_ROW_INDEX 3
#define CONFIRM_ALERT_BUTTON_INDEX 1

#pragma mark - Private

- (void)notifyDelegateFulfill {
    if ([self.delegate respondsToSelector:@selector(fulfillRequestViewController:)]) {
        [self.delegate fulfillRequestViewController:self];
    }
}

- (void)notifyDelegateDecline {
    if ([self.delegate respondsToSelector:@selector(declineRequestViewController:)]) {
        [self.delegate declineRequestViewController:self];
    }
}

- (void)confirmDecline {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to decline this money request?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark - Events

- (IBAction)decline:(id)sender {
    [self confirmDecline];
}

- (IBAction)fulfill:(id)sender {
    [self notifyDelegateFulfill];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == CONFIRM_ALERT_BUTTON_INDEX) {
        [self notifyDelegateDecline];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Detail Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case DETAIL_NAME_ROW_INDEX:
            cell.textLabel.text = @"From";
            cell.detailTextLabel.text = self.moneyRequest.source.name;
            break;
        case DETAIL_AMOUNT_ROW_INDEX:
            cell.textLabel.text = @"Amount";
            cell.detailTextLabel.text = [self.moneyRequest.amount displayAmount];
            break;
        case DETAIL_DATE_ROW_INDEX:
            cell.textLabel.text = @"When";
            cell.detailTextLabel.text = [self.moneyRequest.requested longDateTime];
            break;
        case DETAIL_NOTES_ROW_INDEX:
            cell.textLabel.text = @"Notes";
            cell.detailTextLabel.text = self.moneyRequest.notes;
            break;
        default:
            break;
    }
    
    return cell;
}

@end
