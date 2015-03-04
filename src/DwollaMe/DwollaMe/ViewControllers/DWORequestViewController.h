//
//  DWORequestViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/25/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>
// models
#import "DWOMoneyRequest.h"

@protocol DWORequestViewControllerDelegate;

@interface DWORequestViewController : UIViewController

@property (nonatomic, weak) id<DWORequestViewControllerDelegate> delegate;
@property (nonatomic, strong) DWOMoneyRequest *moneyRequest;

@end

@protocol DWORequestViewControllerDelegate <NSObject>

@optional

- (void)declineRequestViewController:(DWORequestViewController *)requestViewController;
- (void)fulfillRequestViewController:(DWORequestViewController *)requestViewController;

@end