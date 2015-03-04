//
//  DWOOAuthViewController.m
//  DwollaMe
//
//  Created by Josh Aaseby on 12/31/13.
//  Copyright (c) 2013 Josh Aaseby. All rights reserved.
//

#import "DWOOAuthViewController.h"
// models
#import "DWOCredentials.h"
// categories
#import "NSString+URLEncoding.h"
#import "UIColor+Dwolla.h"
// constants
#import "DWORestApiConstants.h"

@interface DWOOAuthViewController () <UIWebViewDelegate, NSURLConnectionDataDelegate> {
    long long expectedContentLength;
    long long receivedDataLength;
    NSMutableData *_data;
}
@property (weak, nonatomic) UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic, readonly) NSString *encodedKey;
@property (weak, nonatomic, readonly) NSString *encodedSecret;
@property (weak, nonatomic, readonly) NSString *encodedRedirectUri;
@end

@implementation DWOOAuthViewController

#pragma mark - Properties

- (NSString *)encodedKey {
    return [[DWOCredentials sharedCredentials].key urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodedSecret {
    return [[DWOCredentials sharedCredentials].secret urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodedRedirectUri {
    return [kDWOBaseUrlTest urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Private

- (void)oauth {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.webView.delegate = self;
    NSString* scopes = [@"accountinfofull|send|transactions|contacts|balance|request|funding|manageaccount" urlEncodeUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [NSString stringWithFormat:@"%@oauth/v2/authenticate?client_id=%@&response_type=code&redirect_uri=%@&scope=%@", kDWOBaseUrlTest, self.encodedKey, self.encodedRedirectUri, scopes];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    [connection start];
}

- (void)loggedIn {
    [self.delegate loggedInWithOAuthViewController:self];
}

- (void)addProgressViewToNavBar {
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.tintColor = [UIColor dwollaOrangeColor];
    
    UIView *navView = self.navigationController.view;
    [navView addSubview:progressView];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    [navView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[navBar]-[progressView(2@20)]"
                                                                        options:NSLayoutFormatDirectionLeadingToTrailing
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(progressView, navBar)]];
    
    [navView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[progressView]|"
                                                                        options:NSLayoutFormatDirectionLeadingToTrailing
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(progressView)]];
    
    [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [progressView setProgress:0 animated:NO];
    self.progressView = progressView;
}

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProgressViewToNavBar];
    [self oauth];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    expectedContentLength = response.expectedContentLength;
    receivedDataLength = 0;
    self.progressView.progress = 0;
    _data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_data) {
        [_data appendData:data];
        receivedDataLength += data.length;
        self.progressView.progress = receivedDataLength / expectedContentLength;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.progressView.progress = 1;
    [self.webView loadData:_data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:connection.currentRequest.URL];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* requestString = [[request URL] absoluteString];
    if ([requestString rangeOfString:@"?code=" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSString* code = [[requestString componentsSeparatedByString:@"code="] objectAtIndex:1];
        NSString* response =  [self getTokenWithCode:code];
        
        if ([response isEqualToString:@"success"])
        {
            [self loggedIn];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Login" message:@"There was an error with your e-mail/password combination. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
#warning users can still get off the reservation and not sign in
            [self oauth];
        }
    }
    return YES;
}

- (NSString *)getTokenWithCode:(NSString *)code {
    NSString* url = [NSString stringWithFormat:@"%@oauth/v2/token?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@", kDWOBaseUrlTest, self.encodedKey, self.encodedSecret, self.encodedRedirectUri, code];
    NSDictionary* response = [self makeGetRequest:url];
    
    if ([response objectForKey:@"access_token"])
    {
        [DWOCredentials sharedCredentials].token = [response objectForKey:@"access_token"];
        return @"success";
    }
    else
    {
        return [response valueForKey:@"error_description"];
    }
}

- (NSDictionary *)makeGetRequest:(NSString *)url {
    NSError *error;
    NSURLResponse *response;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

@end
