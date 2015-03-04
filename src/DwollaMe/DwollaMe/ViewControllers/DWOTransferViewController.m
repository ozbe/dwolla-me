//
//  DWOSend2ViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/2/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWOTransferViewController.h"
// view controllers
#import "DWOConfirmSendViewController.h"
// models
#import "DWOFundingSourcesPicker.h"
// views
#import "DWOAvatarImageView.h"
#import "DWOSendToolbar.h"
// vendors
#import "TSCurrencyTextField.h"
#import "SVProgressHUD.h"
#import "EAMTextView.h"
#import "TestFlight.h"
#import "SDCAlertView.h"
// categories
#import "UIColor+Dwolla.h"
#import "NSError+Dwolla.h"
#import "NSNumber+Dwolla.h"

@interface DWOTransferViewController () <DWOFundingSourcesPickerDelegate, DWOSendToolbarDelegate, DWOConfirmSendViewControllerDelegate, UITextViewDelegate, SDCAlertViewDelegate>
@property (weak, nonatomic) IBOutlet DWOAvatarImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet TSCurrencyTextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;
@property (weak, nonatomic) IBOutlet EAMTextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIPickerView *sourcePickerView;
@property (weak, nonatomic) IBOutlet UILabel *transferDelayWarningLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *requestScrollView;
@property (weak, nonatomic) IBOutlet DWOSendToolbar *sendToolbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notesTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notesTextViewBottomConstraint;

@property (nonatomic, strong) DWOFundingSourcesPicker *sourcePicker;
@property (nonatomic, weak) UIView *focusedView;
@property (nonatomic, strong) DWOSendResponse *sendResponse;
@property (nonatomic, strong) NSOperationQueue *sendQueue;

@property (nonatomic, weak) SDCAlertView *alertView;

@end

@implementation DWOTransferViewController

#pragma mark - Properties

- (DWOFundingSourcesPicker *)sourcePicker{
    if (!_sourcePicker) {
        _sourcePicker = [[DWOFundingSourcesPicker alloc] init];
    }
    return _sourcePicker;
}

- (void)setFocusedView:(UIView *)focusedView {
    if (self.focusedView == focusedView) {
        return;
    }
    
    UIView *oldFocusedView = self.focusedView;
    _focusedView = focusedView;
    [self onFocusedViewChangedFromView:oldFocusedView];
}

- (NSOperationQueue *)sendQueue {
    if (!_sendQueue) {
        _sendQueue = [[NSOperationQueue alloc] init];
        _sendQueue.name = @"Send Queue";
        _sendQueue.maxConcurrentOperationCount = 1;
    }
    return _sendQueue;
}

#pragma mark - Private

- (void)onFocusedViewChangedFromView:(UIView *)view {
    [self handleOldFocusedView:view];
    [self handleNewFocusedView];
    [self updateToolbarNavigation];
}

- (void)handleOldFocusedView:(UIView *)view {
    if (view == self.sourceButton) {
        [self.sourceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (self.focusedView == self.sourceButton) {
        [view resignFirstResponder];
    }
}

- (void)handleNewFocusedView {
    if (self.focusedView == self.sourceButton) {
        [self.sourceButton setTitleColor:[UIColor dwollaOrangeColor] forState:UIControlStateNormal];
    }
}

- (void)updateToolbarNavigation {
    if (self.focusedView == self.amountTextField) {
        self.sendToolbar.previousEnabled = NO;
        self.sendToolbar.nextEnabled = YES;
    } else if (self.focusedView == self.notesTextView) {
        self.sendToolbar.previousEnabled = YES;
        self.sendToolbar.nextEnabled = NO;
    } else {
        self.sendToolbar.previousEnabled = YES;
        self.sendToolbar.nextEnabled = YES;
    }
}

- (void)focusOnPreviousView {
    if (self.focusedView == self.sourceButton) {
        [self.amountTextField becomeFirstResponder];
    } else if (self.focusedView == self.notesTextView) {
        self.focusedView = self.sourceButton;
    }
}

- (void)focusOnNextView {
    if (self.focusedView == self.amountTextField) {
        self.focusedView = self.sourceButton;
    } else if (self.focusedView == self.sourceButton) {
        [self.notesTextView becomeFirstResponder];
    }
}

- (void)updateIsValid {
    self.sendToolbar.sendEnabled = [self.transferStrategy.amount doubleValue] > 0;
}

- (NSString *)createSendConfirmMessage {
    return [NSString stringWithFormat:@"Enter pin to confirm sending %@ to %@", [self.transferStrategy.amount displayAmount], self.nameLabel.text];
}

- (void)confirmSend {
    SDCAlertView *alertView = [[SDCAlertView alloc] initWithTitle:@"Confirm"
                                                          message:[self createSendConfirmMessage]
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:nil];
    alertView.alertViewStyle = SDCAlertViewStyleSecureTextInput;
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.placeholder = @"●●●●";
    textField.textAlignment = NSTextAlignmentCenter;
    [textField addTarget:self action:@selector(pinTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [alertView show];
    self.alertView = alertView;
}

- (void)send {
    __weak DWOTransferViewController *self_weak = self;
    [SVProgressHUD showWithStatus:@"Sending" maskType:SVProgressHUDMaskTypeClear];
    [TestFlight passCheckpoint:@"Submit send"];
    
    [self.sendQueue addOperationWithBlock:^{
        NSError *error = [self_weak.transferStrategy process];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [SVProgressHUD dismiss];
            
            if (!error) {
                [self_weak performSegueWithIdentifier:@"Confirm" sender:self];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error dwollaErrorMessageWithDefaultMessage:@"Unknown error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }];
    }];
}

#pragma mark - Events

- (IBAction)cancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendViewController:cancelled:)]) {
        [self.delegate sendViewController:self cancelled:nil];
    }
}

- (IBAction)amountTextFieldValueChanged:(TSCurrencyTextField *)sender {
    self.transferStrategy.amount = sender.amount;
    self.sendToolbar.showAcceptFee = [self.transferStrategy.amount doubleValue] > 10;
    [self updateIsValid];
}

- (IBAction)updateFocusedViewToSender:(UIView *)sender {
    self.focusedView = sender;
}

- (void)pinTextFieldEditingChanged:(UITextField *)sender {
    NSString *inputText = sender.text;
    
    if (inputText.length == 4) {
        self.transferStrategy.pin = inputText;
        [self.alertView dismissWithClickedButtonIndex:1 animated:NO];
    }
}

#pragma mark - Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TestFlight passCheckpoint:@"Started send"];
    
    self.transferDelayWarningLabel.hidden = YES;
    self.nameLabel.text = self.transferStrategy.name;
    self.avatarImageView.imageUrl = self.transferStrategy.imageUrl;
    self.notesTextView.text = self.transferStrategy.notes;
    self.amountTextField.amount = self.transferStrategy.amount;
    
    UIEdgeInsets contentInset = self.requestScrollView.contentInset;
    contentInset.top = self.navigationController.navigationBar.frame.size.height + 10;
    self.requestScrollView.contentInset = contentInset;
    self.requestScrollView.scrollsToTop = YES;
    
    self.amountTextField.amount = self.transferStrategy.amount;
    
    self.sendToolbar.delegate = self;
    self.sendToolbar.sendEnabled = NO;
    self.sendToolbar.showAcceptFee = [self.transferStrategy.amount doubleValue] > 10;
    
    self.notesTextView.scrollsToTop = NO;
    self.notesTextView.placeholder = @"Notes";
    self.notesTextView.autoresizesVertically = YES;
    self.notesTextView.text = self.transferStrategy.notes;
    
    self.sourcePicker.delegate = self;
    self.sourcePicker.destination = [[DWODestination alloc] initWithDestinationId:self.transferStrategy.destinationId destinationType:self.transferStrategy.destinationType];
    self.sourcePickerView.delegate = self.sourcePicker;
    self.sourcePickerView.dataSource = self.sourcePicker;
    [self.sourcePicker beginLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateIsValid];
    [self.amountTextField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Confirm"]) {
        UINavigationController *navController = segue.destinationViewController;
        DWOConfirmSendViewController *confirmSendViewController = (DWOConfirmSendViewController *)navController.topViewController;
        confirmSendViewController.delegate = self;
        confirmSendViewController.transferStrategy = self.transferStrategy;
        confirmSendViewController.sendResponse = self.sendResponse;
    }
}

#pragma mark - DWOConfirmSendViewControllerDelegate

- (void)requestDismissConfirmSendViewController:(DWOConfirmSendViewController *)confirmSendViewController {
    [confirmSendViewController dismissViewControllerAnimated:NO completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(sendViewController:sent:response:)]) {
        [self.delegate sendViewController:self sent:nil response:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIView *)backgroundViewForConfirmSendViewController:(DWOConfirmSendViewController *)confirmSendViewController {
    return self.navigationController.view;
}

#pragma mark - DWOFundingSourcesPickerDelegate

- (void)fundingSourcesPicker:(DWOFundingSourcesPicker *)fundingSourcesPicker didSelectFundingSource:(DWOFundingSource *)fundingSource {
    self.transferStrategy.fundsSource = fundingSource.fundingSourceId;
    [self.sourceButton setTitle:fundingSource.name forState:UIControlStateNormal];
    self.transferDelayWarningLabel.hidden = ![fundingSource.processingType isEqualToString:@"ACH"];
}

- (void)fundingSourcesPickerDidFinishLoading:(DWOFundingSourcesPicker *)fundingSourcesPicker {
    [self.sourcePickerView reloadAllComponents];
}

#pragma mark - DWOSendToolbarDelegate

- (void)sendToolbarAcceptFeeTouched:(DWOSendToolbar *)sendToolbar {
    self.transferStrategy.acceptFee = !self.transferStrategy.acceptFee;
    self.sendToolbar.acceptFee = self.transferStrategy.acceptFee;
}

- (void)sendToolbarPreviousTouched:(DWOSendToolbar *)sendToolbar {
    [self focusOnPreviousView];
}

- (void)sendToolbarNextTouched:(DWOSendToolbar *)sendToolbar {
    [self focusOnNextView];
}

- (void)sendToolbarSendTouched:(DWOSendToolbar *)sendToolbar {
    [self confirmSend];
}

#pragma mark - SDCAlertViewDelegate

- (void)alertView:(SDCAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self send];
    }
}

#pragma mark - UITextViewDelegate

- (void) textViewDidChange:(UITextView *)textView {
    if (textView == self.notesTextView) {
        self.transferStrategy.notes = textView.text;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.focusedView = textView;
}

@end
