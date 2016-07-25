//
//  RSWebViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/16.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSWebViewController.h"
#import "RSWebView.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface RSWebViewController ()

@end

@implementation RSWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isEncodeURL = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)initWebView
{
    NSURL *url;
    _bannerView = [[RSWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-64);
    self.bannerView.backgroundColor = RS_Background_Color;
    _bannerView.delegate = self;
    if (self.isEncodeURL) {
        self.urlString = [self.urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    url = [NSURL URLWithString:self.urlString];
    if(!url) {
        [RSToastView alertView:@"URL地址错误"];
        return;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [_bannerView loadRequest:request];
    [self.view addSubview:_bannerView];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[RSToastView shareRSToastView]showHUD:@""];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[RSToastView shareRSToastView]hidHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [[RSToastView shareRSToastView]hidHUD];
    
    // Ignore NSURLErrorDomain error -999.
    if (error.code == NSURLErrorCancelled) return;
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;

    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    [[RSToastView shareRSToastView]showToast:errmsg];
}



@end