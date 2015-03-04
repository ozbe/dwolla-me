//
//  DWOSendToolbar.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/2/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOSendToolbar.h"
// categories
#import "UIColor+Dwolla.h"

@interface DWOSendToolbar ()
@property (nonatomic, assign) CALayer *bottomLayer;
@property (nonatomic, weak) UIButton *acceptFeeButton;
@property (nonatomic, weak) UIBarButtonItem *previousBarButtonItem;
@property (nonatomic, weak) UIBarButtonItem *nextBarButtonItem;
@property (nonatomic, weak) UIBarButtonItem *sendBarButtonItem;
@end

@implementation DWOSendToolbar

#pragma mark - Properties

- (BOOL)showAcceptFee {
    return !self.acceptFeeButton.hidden;
}

- (void)setShowAcceptFee:(BOOL)showAcceptFee {
    self.acceptFeeButton.hidden = !showAcceptFee;
}

- (void)setAcceptFee:(BOOL)acceptFee {
    _acceptFee = acceptFee;
    [self updateAcceptFee];
}

- (BOOL)isPreviousEnabled {
    return self.previousBarButtonItem.enabled;
}

- (void)setPreviousEnabled:(BOOL)previousEnabled {
    self.previousBarButtonItem.enabled = previousEnabled;
    [self setNeedsLayout];
}

- (BOOL)isNextEnabled {
    return self.nextBarButtonItem.enabled;
}

- (void)setNextEnabled:(BOOL)nextEnabled {
    self.nextBarButtonItem.enabled = nextEnabled;
}

- (BOOL)isSendEnabled {
    return self.sendBarButtonItem.enabled;
}

- (void)setSendEnabled:(BOOL)sendEnabled {
    self.sendBarButtonItem.enabled = sendEnabled;
}

- (void)setBottomLayer:(CALayer *)bottomLayer {
    [self.bottomLayer removeFromSuperlayer];
    _bottomLayer = bottomLayer;
    [self.layer addSublayer:self.bottomLayer];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.bottomLayer = [self createBottomBorder];
}

#pragma mark - Initializers

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UIImage *previousImage = [[UIImage imageNamed:@"left-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *previousImageDown = [[UIImage imageNamed:@"left-arrow-down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        UIImage *nextImage = [[UIImage imageNamed:@"right-arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *nextImageDown = [[UIImage imageNamed:@"right-arrow-down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previousButton.frame = CGRectMake(0, 0, 40, 30);
        [previousButton setImage:previousImage forState:UIControlStateNormal];
        [previousButton setImage:previousImageDown forState:UIControlStateHighlighted];
        [previousButton addTarget:self action:@selector(previousButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *previousBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:previousButton];

        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(0, 0, 40, 30);
        [nextButton setImage:nextImage forState:UIControlStateNormal];
        [nextButton setImage:nextImageDown forState:UIControlStateHighlighted];
        [nextButton addTarget:self action:@selector(nextButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *nextBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];

        UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendBarButtonItemTouchedUpInside:)];

        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -19;
        
        UIButton *acceptFeeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [acceptFeeButton setTitle:@"25¢" forState:UIControlStateNormal];
        UIEdgeInsets acceptFeeButtonContentEdgeInsets = acceptFeeButton.contentEdgeInsets;
        acceptFeeButtonContentEdgeInsets.left += 2;
        acceptFeeButton.contentEdgeInsets = acceptFeeButtonContentEdgeInsets;
        [acceptFeeButton.titleLabel setFont:[UIFont fontWithDescriptor:[UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline] size:11]];
        acceptFeeButton.frame = CGRectMake(0, 0, 30, 30);
        acceptFeeButton.layer.borderColor = [UIColor dwollaOrangeColor].CGColor;
        acceptFeeButton.layer.borderWidth = 1;
        acceptFeeButton.layer.cornerRadius = acceptFeeButton.frame.size.height / 2;
        acceptFeeButton.layer.masksToBounds = YES;
        [acceptFeeButton addTarget:self action:@selector(acceptFeeButtonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *acceptFeeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:acceptFeeButton];
        
        [self setItems:@[negativeSeperator, previousBarButtonItem, nextBarButtonItem, flexibleSpace, acceptFeeBarButtonItem, sendBarButtonItem]];
        self.acceptFeeButton = acceptFeeButton;
        self.previousBarButtonItem = previousBarButtonItem;
        self.nextBarButtonItem = nextBarButtonItem;
        self.sendBarButtonItem = sendBarButtonItem;
        [self updateAcceptFee];
    }
 
    return self;
}

#pragma mark - Events

- (void)previousButtonTouchUpInside:(id)sender {
    [self notifyDelegatePreviousTouched];
}

- (void)nextButtonTouchUpInside:(id)sender {
    [self notifyDelegateNextTouched];
}

- (void)sendBarButtonItemTouchedUpInside:(id)sender {
    [self notifyDelegateSendTouched];
}

- (void)acceptFeeButtonTouchedUpInside:(id)sender {
    [self notifyDelegateAcceptFeeTouched];
}

#pragma mark - Private

- (void)updateAcceptFee {
    if (self.acceptFee) {
        self.acceptFeeButton.layer.backgroundColor = [UIColor dwollaOrangeColor].CGColor;
        [self.acceptFeeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.acceptFeeButton.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self.acceptFeeButton setTitleColor:[UIColor dwollaOrangeColor] forState:UIControlStateNormal];
    }

}

- (void)notifyDelegateAcceptFeeTouched {
    if ([self.delegate respondsToSelector:@selector(sendToolbarAcceptFeeTouched:)]) {
        [self.delegate sendToolbarAcceptFeeTouched:self];
    }
}

- (void)notifyDelegatePreviousTouched {
    if ([self.delegate respondsToSelector:@selector(sendToolbarPreviousTouched:)]) {
        [self.delegate sendToolbarPreviousTouched:self];
    }
}

- (void)notifyDelegateNextTouched {
    if ([self.delegate respondsToSelector:@selector(sendToolbarNextTouched:)]) {
        [self.delegate sendToolbarNextTouched:self];
    }
}

- (void)notifyDelegateSendTouched {
    if ([self.delegate respondsToSelector:@selector(sendToolbarSendTouched:)]) {
        [self.delegate sendToolbarSendTouched:self];
    }
}

- (CALayer *)createBottomBorder {
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0.0f, self.frame.size.height - 1.0f, self.frame.size.width, 1.0f);
    border.backgroundColor = [UIColor colorWithRed:206.0/255 green:206.0/255 blue:210.0/255 alpha:1].CGColor;
    return border;
}

@end
