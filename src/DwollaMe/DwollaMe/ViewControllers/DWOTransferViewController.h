//
//  DWOSend2ViewController.h
//  DwollaMe
//
//  Created by Josh Aaseby on 3/2/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// lib
#import "DWOTransferStrategy.h"
// models
#import "DWOSendResponse.h"
#import "DWOSendRequest.h"

@protocol DWOTransferViewControllerDelegate;

@interface DWOTransferViewController : UIViewController

@property (nonatomic, strong) id<DWOTransferViewControllerDelegate> delegate;
@property (nonatomic, strong) id<DWOTransferStrategy> transferStrategy;

@end

@protocol DWOTransferViewControllerDelegate <NSObject>

@optional

- (void)sendViewController:(DWOTransferViewController *)sendViewController sent:(DWOSendRequest *)sent response:(DWOSendResponse *)response;
- (void)sendViewController:(DWOTransferViewController *)sendViewController cancelled:(DWOSendRequest *)request;

@end