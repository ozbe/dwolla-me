//
//  DWOOAuthViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/31/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>

@protocol DWOOAuthViewControllerDelegate;

@interface DWOOAuthViewController : UIViewController

@property (nonatomic, weak) id<DWOOAuthViewControllerDelegate> delegate;

@end

@protocol DWOOAuthViewControllerDelegate <NSObject>

- (void)loggedInWithOAuthViewController:(DWOOAuthViewController *)oAuthViewController;

@end
