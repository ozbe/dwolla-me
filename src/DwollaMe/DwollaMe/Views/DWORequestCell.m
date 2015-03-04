//
//  DWORequestCell.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/24/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWORequestCell.h"

@implementation DWORequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
