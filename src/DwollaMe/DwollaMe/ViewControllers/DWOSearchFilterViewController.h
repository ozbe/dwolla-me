//
//  SearchFilterViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/8/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>
// models
#import "DWOUserSearchFilterOptions.h"
#import "DWOUserSearchFilterOption.h"

@protocol DWOSearchFilterViewControllerDelegate;

@interface DWOSearchFilterViewController : UITableViewController

@property (nonatomic, strong) DWOUserSearchFilterOptions *filterOptions;
@property (nonatomic, weak) id<DWOSearchFilterViewControllerDelegate> delegate;

@end

@protocol DWOSearchFilterViewControllerDelegate <NSObject>

- (void)dismissSearchFilterViewController:(DWOSearchFilterViewController *)searchFilterViewController;

@optional

- (void)searchFilterViewController:(DWOSearchFilterViewController *)searchFilter searchFilterOption:(DWOUserSearchFilterOption *)searchFilterOption enabled:(BOOL)enabled;
@end