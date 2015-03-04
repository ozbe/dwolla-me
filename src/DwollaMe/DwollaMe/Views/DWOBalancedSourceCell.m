//
//  DWOBalancedSourceCell.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/7/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWOBalancedSourceCell.h"
// categories
#import "UIColor+Dwolla.h"
#import "DWOFundingSource+Dwolla.h"
#import "NSNumber+Dwolla.h"

@interface DWOBalancedSourceCell ()
@property (weak, nonatomic) IBOutlet UIButton *withdrawButton;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *depositButton2;
@end

@implementation DWOBalancedSourceCell

#pragma mark - Properties

- (void)setFundingSource:(DWOFundingSource *)fundingSource {
    _fundingSource = fundingSource;
    [self updateActionsVisibility];
    self.nameLabel.text = self.fundingSource.name;
}

- (void)setFundingSourceBalance:(NSNumber *)fundingSourceBalance {
    self.amountLabel.text = [fundingSourceBalance displayAmount];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.depositButton2.layer.borderColor = [UIColor dwollaOrangeColor].CGColor;
    self.depositButton2.layer.borderWidth = 1;
    self.depositButton2.layer.cornerRadius = self.depositButton2.frame.size.width / 2;
    self.depositButton2.layer.masksToBounds = YES;
    UIEdgeInsets edgeInsets = self.depositButton2.contentEdgeInsets;
    edgeInsets.left += 1;
    edgeInsets.bottom += 2;
    self.depositButton2.contentEdgeInsets = edgeInsets;
}

#pragma mark - Private

- (void)updateActionsVisibility {
    BOOL isCash = [self.fundingSource isBalance];
    self.withdrawButton.hidden = !isCash;
    self.depositButton.hidden = !isCash;
}

@end
