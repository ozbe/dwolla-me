//
//  DWOTransactionFilterViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>
// models
#import "DWOBoolSearchOption.h"

@protocol DWOTransactionFilterViewControllerDelegate;

@interface DWOTransactionFilterViewController : UITableViewController

@property (weak, nonatomic) NSArray *types;

@property (nonatomic, weak) id<DWOTransactionFilterViewControllerDelegate> delegate;

@end

@protocol DWOTransactionFilterViewControllerDelegate <NSObject>

@optional

- (void)transactionFilterViewController:(DWOTransactionFilterViewController *)transactionFilter transactionFilterOption:(DWOBoolSearchOption *)searchOption enabled:(BOOL)enabled;

@end
