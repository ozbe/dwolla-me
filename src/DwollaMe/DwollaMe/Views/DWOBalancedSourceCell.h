//
//  DWOBalancedSourceCell.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/7/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// frameworks
#import <UIKit/UIKit.h>
// models
#import "DWOFundingSource.h"

@protocol DWOBalancedSourceCellDelegate;

@interface DWOBalancedSourceCell : UITableViewCell

@property (nonatomic, weak) id<DWOBalancedSourceCellDelegate> delegate;
@property (nonatomic, weak) DWOFundingSource *fundingSource;
@property (nonatomic, strong) NSNumber *fundingSourceBalance;

@end

@protocol DWOBalancedSourceCellDelegate <NSObject>

@optional

// withdraw
// deposit

@end