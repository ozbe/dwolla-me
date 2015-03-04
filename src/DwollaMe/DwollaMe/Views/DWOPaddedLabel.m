//
//  DWOPaddedLabel.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/3/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import "DWOPaddedLabel.h"

@implementation DWOPaddedLabel

#define PADDING 3

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, PADDING, 0, PADDING};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    return CGRectInset([self.attributedText boundingRectWithSize:CGSizeMake(999, 999)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil], -PADDING - 1, 0);
}

@end
