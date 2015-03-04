//
//  DWOConfirmationSendViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/30/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// header
#import "DWOConfirmSendViewController.h"
// categories
#import "UIView+ImageEffects.h"
#import "UIImage+ImageEffects.h"
#import "NSNumber+Dwolla.h"
#import "NSDate+Dwolla.h"
// views
#import "DWOAvatarImageView.h"
// frameworks
#import "Social/Social.h"

@interface DWOConfirmSendViewController ()
@property (weak, nonatomic) IBOutlet DWOAvatarImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation DWOConfirmSendViewController

#pragma mark - Events

- (void)handleDidTakeScreenShot:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ah Ah Ah" message:@"Please don't take screenshots of the confirmation screen." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)share:(id)sender {
    SLComposeViewController *socialViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if (self.transferStrategy.name) {
        [socialViewController setInitialText:[NSString stringWithFormat:@"I just paid %@ with #dwolla", self.transferStrategy.name]];
    } else {
        [socialViewController setInitialText:@"I just paid with #dwolla on my phone"];
    }
    [self presentViewController:socialViewController animated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self.delegate requestDismissConfirmSendViewController:self];
}

#pragma mark - Overrides

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateBackground];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.avatarImageView.imageUrl = self.transferStrategy.imageUrl;
#warning determine if pending
    self.amountLabel.text = [self.transferStrategy.amount displayAmount];
    self.nameLabel.text = self.transferStrategy.name;
    self.dateLabel.text = [self.sendResponse.date longDateTime];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleDidTakeScreenShot:)
                                                 name: UIApplicationUserDidTakeScreenshotNotification
                                               object: nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)updateBackground {
    if ([self.delegate respondsToSelector:@selector(backgroundViewForConfirmSendViewController:)]) {
        UIView *backgroundView = [self.delegate backgroundViewForConfirmSendViewController:self];      
        self.backgroundImageView.image = [backgroundView blurredSnapshot];
    }
}

@end
