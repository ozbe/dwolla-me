//
//  DWOTransactionViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>
// models
#import "DWOTransaction.h"

@interface DWOTransactionViewController : UIViewController

@property (nonatomic, strong) DWOTransaction *transaction;

@end

