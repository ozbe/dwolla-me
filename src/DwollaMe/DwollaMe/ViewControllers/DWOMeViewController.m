//
//  SettingsViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOMeViewController.h"
// frameworks
#import <MessageUI/MessageUI.h>
// models
#import "DWOCredentials.h"
// view controllers
#import "DWOWebViewController.h"
// constants
#import "DWOAppConstants.h"

@interface DWOMeViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation DWOMeViewController

#pragma mark - Static



#pragma mark - Overrides

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Privacy Policy"]) {
        DWOWebViewController *webViewController = (DWOWebViewController *)segue.destinationViewController;
        webViewController.title = @"Privacy Policy";
        webViewController.url = KDWOStaticUrlPrivacyPolicy;
    } else if ([segue.identifier isEqualToString:@"Terms of Service"]) {
        DWOWebViewController *webViewController = (DWOWebViewController *)segue.destinationViewController;
        webViewController.title = @"Terms of Service";
        webViewController.url = kDWOStaticUrlTermsOfService;
    } else if ([segue.identifier isEqualToString:@"Forgot Pin"]) {
        DWOWebViewController *webViewController = (DWOWebViewController *)segue.destinationViewController;
        webViewController.title = @"Forgot Pin";
        webViewController.url = kDWOStaticUrlForgotPin;
    }
}

#pragma mark - Private Methods

- (void)handleSelectEmailSupport {
    if ([MFMailComposeViewController canSendMail]) {
        [self emailSupport];
    } else {
        [self showEmailNotConfiguredAlert];
    }
}

- (void)emailSupport {
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    mailComposeVC.mailComposeDelegate = self;
    [mailComposeVC setToRecipients:@[@"josh@dwolla.com"]];
#warning get app name
    [mailComposeVC setSubject:@"Dwolla Me - Support"];
    [self presentViewController:mailComposeVC animated:YES completion:nil];
}

- (void)showEmailNotConfiguredAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device is not configured to send email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqualToString:@"Email Support"]) {
        [self handleSelectEmailSupport];
    } else if ([cell.reuseIdentifier isEqualToString:@"Logout"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    }
}

@end
