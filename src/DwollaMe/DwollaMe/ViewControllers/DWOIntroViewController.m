//
//  DWOIntroViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 3/11/14.
//  Copyright (c) Josh Aaseby. All rights reserved.
//

// header
#import "DWOIntroViewController.h"
// categories
#import "UIColor+Dwolla.h"

@interface DWOIntroViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) NSArray *pageViews;
@property (nonatomic, strong) DWOOAuthViewController *oAuthViewController;
@end

@implementation DWOIntroViewController

#pragma mark - Properties

- (DWOOAuthViewController *)oAuthViewController {
    if (!_oAuthViewController) {
        _oAuthViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OAuthViewController"];
    }
    return _oAuthViewController;
}

- (id<DWOOAuthViewControllerDelegate>)oAuthDelegate {
    return self.oAuthViewController.delegate;
}

- (void)setOAuthDelegate:(id<DWOOAuthViewControllerDelegate>)oAuthDelegate {
    self.oAuthViewController.delegate = oAuthDelegate;
}

#pragma mark - Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load views
    // 1. send
    // 2. banks
    // 3. merchants
    // last. login
    
    // set button borders and colors
    [self.signupButton setTitleColor:[UIColor dwollaOrangeColor] forState:UIControlStateNormal];
    self.loginButton.layer.borderColor = [UIColor dwollaOrangeColor].CGColor;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 3;
    self.loginButton.layer.masksToBounds = YES;
    
    [self.signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signupButton.backgroundColor = [UIColor dwollaOrangeColor];
    self.signupButton.layer.cornerRadius = 3;
    self.signupButton.layer.masksToBounds = YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // adjust buttons alpha
}

@end
