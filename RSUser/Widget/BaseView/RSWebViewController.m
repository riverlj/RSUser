//
//  RSWebViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/16.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSWebViewController.h"
#import "RSWebView.h"

@interface RSWebViewController ()

@end

@implementation RSWebViewController
{
    RSWebView *bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self comeBack:nil];
    [self initWebView];
}

-(void)initWebView
{
    NSURL *url;
    bannerView = [[RSWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth+kUITabBarHeight)];
    bannerView.delegate = self;
    url = [NSURL URLWithString:self.urlString];
    if(!url) {
        [RSToastView alertView:@"URL地址错误"];
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.timeoutInterval = 5;
    [bannerView loadRequest:request];
    [self.view addSubview:bannerView];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSMutableURLRequest *req = [request mutableCopy];
    NSString *urlStr = [req.URL absoluteString];
    //判断是否有带上统计参数
    if([urlStr rangeOfString:@"utm_campaign="].location == NSNotFound) {
        req.URL = [NSURL URLWithString:[urlStr urlWithHost:nil]];
        [bannerView loadRequest:req];
        return false;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[RSToastView shareRSAlertView]showHUD:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[RSToastView shareRSAlertView]hidHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [[RSToastView shareRSAlertView]hidHUD];
    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    [RSToastView alertView:errmsg];
}

@end