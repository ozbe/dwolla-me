//
//  DWOFundViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 2/4/14.
//  Copyright (c) 2014 Josh Aaseby. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>
// models
#import "DWOFundStrategy.h"
#import "DWOFundRequest.h"

@protocol DWOFundViewControllerDelegate;

@interface DWOFundViewController : UITableViewController

@property (nonatomic, weak) id<DWOFundViewControllerDelegate> delegate;
@property (nonatomic, strong) id<DWOFundStrategy> fundStrategy;

@end

@protocol DWOFundViewControllerDelegate <NSObject>

- (void)didCancelFundViewController:(DWOFundViewController *)fundViewController;
- (void)fundViewController:(DWOFundViewController *)fundViewController didSubmitRequest:(DWOFundRequest *)request transaction:(DWOTransaction *)transaction;
- (void)fundViewController:(DWOFundViewController *)fundViewController didSubmitRequest:(DWOFundRequest *)request error:(NSError *)error;

@end
