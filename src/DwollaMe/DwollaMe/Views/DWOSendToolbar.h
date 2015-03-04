//
//  DWOSendToolbar.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/2/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DWOSendToolbar;

@protocol DWOSendToolbarDelegate <NSObject, UIToolbarDelegate>

@optional

- (void)sendToolbarAcceptFeeTouched:(DWOSendToolbar *)sendToolbar;
- (void)sendToolbarPreviousTouched:(DWOSendToolbar *)sendToolbar;
- (void)sendToolbarNextTouched:(DWOSendToolbar *)sendToolbar;
- (void)sendToolbarSendTouched:(DWOSendToolbar *)sendToolbar;

@end

@interface DWOSendToolbar : UIToolbar

@property (nonatomic, assign) BOOL acceptFee;
@property (nonatomic, assign, getter = isPreviousEnabled) BOOL previousEnabled;
@property (nonatomic, assign, getter = isNextEnabled) BOOL nextEnabled;
@property (nonatomic, assign, getter = isSendEnabled) BOOL sendEnabled;
@property (nonatomic, assign) BOOL showAcceptFee;
@property (nonatomic, assign) id<DWOSendToolbarDelegate> delegate;

@end

