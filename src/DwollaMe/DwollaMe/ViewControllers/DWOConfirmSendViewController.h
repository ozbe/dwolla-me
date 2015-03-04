//
//  DWOConfirmationSendViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/30/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// lib
#import "DWOTransferStrategy.h"
// models
#import "DWOSendResponse.h"

@protocol DWOConfirmSendViewControllerDelegate;

@interface DWOConfirmSendViewController : UIViewController

@property (nonatomic, weak) id<DWOConfirmSendViewControllerDelegate> delegate;
@property (nonatomic, strong) id<DWOTransferStrategy> transferStrategy;
@property (nonatomic, strong) DWOSendResponse *sendResponse;

@end

@protocol DWOConfirmSendViewControllerDelegate <NSObject>

- (void)requestDismissConfirmSendViewController:(DWOConfirmSendViewController *)confirmSendViewController;

@optional

- (UIView *)backgroundViewForConfirmSendViewController:(DWOConfirmSendViewController *)confirmSendViewController;

@end
