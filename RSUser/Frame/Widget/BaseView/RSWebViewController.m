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
    NSMutableURLRequest *req = [request mutableCopy];
    NSString *urlStr = [req.URL absoluteString];
    //判断是否有带上统计参数
    if([urlStr rangeOfString:@"utm_campaign="].location == NSNotFound) {
        req.URL = [NSURL URLWithString:[urlStr urlWithHost:nil]];
        [_bannerView loadRequest:req];
        return false;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[RSToastView shareRSToastView]showHUD:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[RSToastView shareRSToastView]hidHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [[RSToastView shareRSToastView]hidHUD];
    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    [RSToastView alertView:errmsg];
}




@end