//
//  DWOIntroViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/11/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import <UIKit/UIKit.h>
// view controllers
#import "DWOOAuthViewController.h"

@interface DWOIntroViewController : UIViewController

@property (nonatomic, weak) id<DWOOAuthViewControllerDelegate> oAuthDelegate;

@end
