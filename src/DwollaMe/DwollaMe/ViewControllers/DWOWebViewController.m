//
//  ForgotPinViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/19/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOWebViewController.h"

@interface DWOWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DWOWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

@end
