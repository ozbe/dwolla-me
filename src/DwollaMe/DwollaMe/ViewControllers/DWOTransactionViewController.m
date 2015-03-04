//
//  DWOTransactionViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// header
#import "DWOTransactionViewController.h"
// view controllers
#import "DWOTransferViewController.h"
// models
#import "DWOTransactionFee.h"
// categories
#import "DWOTransaction+Display.h"
#import "DWOTransaction+Dwolla.h"
#import "NSDate+Dwolla.h"
// vendors
#import "TestFlight.h"

@interface DWOTransactionViewController () <DWOTransferViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refundBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation DWOTransactionViewController

#define DETAIL_SECTION_INDEX 0
#define FEE_SECTION_INDEX 1
#define DETAIL_NAME_ROW_INDEX 0
#define DETAIL_AMOUNT_ROW_INDEX 1
#define DETAIL_DATE_ROW_INDEX 2
#define DETAIL_NOTE_ROW_INDEX 3
#define DETAIL_CLEARING_DATE_INDEX 4

#pragma mark - Events

- (IBAction)send:(id)sender {
    [self performSegueWithIdentifier:@"Send" sender:self];
}

#pragma mark - Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];

    [TestFlight passCheckpoint:@"View transaction details"];
    
    self.title = [self.transaction displayType];
    self.toolbar.hidden = ![self.transaction isTransfer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Send"]) {
        UINavigationController *navController = segue.destinationViewController;
        DWOTransferViewController *sendViewController = (DWOTransferViewController *)navController.topViewController;
        sendViewController.delegate = self;
#warning send!!!
        //sendViewController.sendRequest = [self.transaction convertToSendStrategy];
    }
}

#pragma mark - DWOSendViewController

- (void)sendViewController:(DWOTransferViewController *)sendViewController cancelled:(DWOSendRequest *)request {
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendViewController:(DWOTransferViewController *)sendViewController sent:(DWOSendRequest *)sent response:(DWOSendResponse *)response {
    [sendViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.transaction.fees.count) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case DETAIL_SECTION_INDEX:
            return self.transaction.clearingDate ? 5 : 4;
        case FEE_SECTION_INDEX:
            return self.transaction.fees.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Detail Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (indexPath.section == DETAIL_SECTION_INDEX) {
        switch (indexPath.row) {
            case DETAIL_NAME_ROW_INDEX:
                cell.textLabel.text = [self isOutgoing] ? @"To" : @"From";
                cell.detailTextLabel.text = self.transaction.name;
                break;
            case DETAIL_AMOUNT_ROW_INDEX:
                cell.textLabel.text = @"Amount";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.02f", [self.transaction.amount doubleValue]];
                break;
            case DETAIL_DATE_ROW_INDEX:
                cell.textLabel.text = @"When";
                cell.detailTextLabel.text = [self.transaction.date longDateTime];
                break;
            case DETAIL_NOTE_ROW_INDEX:
                cell.textLabel.text = @"Notes";
                cell.detailTextLabel.text = self.transaction.notes;
                break;
            case DETAIL_CLEARING_DATE_INDEX:
                cell.textLabel.text = @"Clearing Date";
                cell.detailTextLabel.text = [self.transaction.clearingDate shortDate];
            default:
                break;
        }
    } else if (indexPath.section == FEE_SECTION_INDEX) {
        DWOTransactionFee *fee = [self.transaction.fees objectAtIndex:indexPath.row];
        cell.textLabel.text = fee.type;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.02f", [fee.amount doubleValue]];
    }
    
    return cell;
}

- (BOOL)isOutgoing {
    return self.transaction.type == DWOTransactionTypeMoneySent || self.transaction.type == DWOTransactionTypeWithdrawal;
}

@end
