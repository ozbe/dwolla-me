//
//  DWOTransactionCell.h
//  DwollaMe
//
//  Created by Josh Aaseby on 12/25/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

// views
#import "DWOAvatarImageView.h"
// models
#import "DWOTransaction.h"
// vendors
#import "SWTableViewCell.h"

@interface DWOTransactionCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet DWOAvatarImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
