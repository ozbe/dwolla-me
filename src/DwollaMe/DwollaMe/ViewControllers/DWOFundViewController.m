//
//  DWOFundViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 2/4/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

#import "DWOFundViewController.h"
// models
#import "DWOFundingSourcesPicker.h"
#import "DWOFundingSource.h"
// vendors
#import "TSCurrencyTextField.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"
// constants
#import "DWOErrorConstants.h"

@interface DWOFundViewController () <DWOFundingSourcesPickerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet TSCurrencyTextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *pinTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *fundingSourcesPickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (nonatomic, strong) DWOFundingSourcesPicker * fundingSourcesPicker;
@property (nonatomic, strong) DWOFundRequest *fundRequest;
@property (nonatomic, strong) DWOFundingSource *selectedFundingSource;
@property (nonatomic, readonly) BOOL isSelectedFundingSourceAch;
@property (nonatomic, strong) NSOperationQueue *fundQueue;
@end

@implementation DWOFundViewController

#define FUNDING_SOURCE_SECTION_INDEX 2

static NSString *SOURCE_FOOTER_ACH_DISCLAIMER = @"Transfers from your bank account will be transfered in 3-4 business days.";

#pragma mark - Properties

- (DWOFundingSourcesPicker *)fundingSourcesPicker {
    if (!_fundingSourcesPicker) {
        _fundingSourcesPicker = [[DWOFundingSourcesPicker alloc] init];
    }
    return _fundingSourcesPicker;
}

- (DWOFundRequest *)fundRequest {
    if (!_fundRequest) {
        _fundRequest = [[DWOFundRequest alloc] init];
    }
    return _fundRequest;
}

- (void)setSelectedFundingSource:(DWOFundingSource *)selectedFundingSource {
    if (_selectedFundingSource != selectedFundingSource) {
        _selectedFundingSource = selectedFundingSource;
        self.fundRequest.fundingSourceId = selectedFundingSource.fundingSourceId;
        [self updateFundingSourceSectionFooter];
    }
}

- (BOOL)isSelectedFundingSourceAch {
    return [self.selectedFundingSource.processingType isEqualToString:@"ACH"];
}

- (NSOperationQueue *)fundQueue {
    if (!_fundQueue) {
        _fundQueue = [[NSOperationQueue alloc] init];
        _fundQueue.name = @"Fund Queue";
        _fundQueue.maxConcurrentOperationCount = 1;
    }
    return _fundQueue;
}

#pragma mark - Events

- (IBAction)amountTextFieldEditingChanged:(TSCurrencyTextField *)sender {
    self.fundRequest.amount = sender.amount;
    [self updateSubmitEnabled];
}

- (IBAction)pinTextFieldChanged:(UITextField *)sender {
    self.fundRequest.pin = sender.text;
    [self updateSubmitEnabled];
}

- (IBAction)cancel:(id)sender {
    [self notifyDelegateDidCancel];
}

- (IBAction)submit:(id)sender {
    __weak DWOFundViewController *self_weak = self;
    
    [SVProgressHUD showWithStatus:@"Processing" maskType:SVProgressHUDMaskTypeClear];
    
    [self.fundQueue addOperationWithBlock:^{
        NSError *error;
        DWOTransaction *transaction = [self_weak.fundStrategy submitRequest:self_weak.fundRequest error:&error];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD dismiss];
            [self_weak didSubmitRequest:self_weak.fundRequest transaction:transaction error:error];
        }];
    }];
}

#pragma mark - Private

- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)notifyDelegateDidCancel {
    [self.delegate didCancelFundViewController:self];
}

- (void)didSubmitRequest:(DWOFundRequest *)request transaction:(DWOTransaction *)transaction error:(NSError *)error {
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Submit %@", self.fundStrategy.submitTitle]];

    if (error) {
        [self displayAlertWithTitle:@"Error" message:[error.userInfo objectForKey:kDWOErrorUserInfoKeyMessage]];
        [self.delegate fundViewController:self didSubmitRequest:request error:error];
    } else {
        [self displayAlertWithTitle:@"Pending" message:@"Your deposit has been successfully submitted and will be processed."];
        [self.delegate fundViewController:self didSubmitRequest:request transaction:transaction];
    }
}

- (void)updateFundingSourceSectionFooter {
    [self.tableView reloadData];
}

- (void)addRightPaddingToTextField:(UITextField *)textField {
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 10)];
    [textField setRightViewMode:UITextFieldViewModeAlways];
    [textField setRightView:spacerView];
}

- (void)updateSubmitEnabled {
    self.submitButton.enabled = [self.fundStrategy isValidRequest:self.fundRequest];
}

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRightPaddingToTextField:self.amountTextField];
    [self addRightPaddingToTextField:self.pinTextField];

    self.fundingSourcesPicker.delegate = self;
    self.fundingSourcesPickerView.delegate = self.fundingSourcesPicker;
    self.fundingSourcesPickerView.dataSource = self.fundingSourcesPicker;
    [self.fundingSourcesPicker beginLoading];
    
    self.submitButton.title = self.fundStrategy.submitTitle;
    
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Started %@", self.fundStrategy.submitTitle]];
    [self updateSubmitEnabled];
}



#pragma mark - DWOFundingSourcesPickerDelegate

- (void)fundingSourcesPickerDidFinishLoading:(DWOFundingSourcesPicker *)fundingSourcesPicker {
    [self.fundingSourcesPickerView reloadAllComponents];
    self.selectedFundingSource = [self.fundingSourcesPicker fundingSourceForRow:0 forComponent:0];
}

- (void)fundingSourcesPicker:(DWOFundingSourcesPicker *)fundingSourcesPicker didSelectFundingSource:(DWOFundingSource *)fundingSource {
    self.selectedFundingSource = fundingSource;
}

- (BOOL)fundingSourcesPicker:(DWOFundingSourcesPicker *)fundingSourcesPicker shouldIncludeFundingSource:(DWOFundingSource *)fundingSource {
    return [self.fundStrategy isValidFundingSource:fundingSource];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return (section == FUNDING_SOURCE_SECTION_INDEX && self.isSelectedFundingSourceAch) ? SOURCE_FOOTER_ACH_DISCLAIMER : nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.pinTextField) {
        NSUInteger newLength = textField.text.length + string.length - range.length;
        return (newLength <= 4);
    }
    return YES;
}

@end
