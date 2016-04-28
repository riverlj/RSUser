//
//  PayWebViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/27.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "PayWebViewController.h"

@interface PayWebViewController ()

@end

@implementation PayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付方式";
//    [self setStateBarBg];
    self.navigationController.navigationBar.hidden = NO;
    self.bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
}

- (void)setStateBarBg
{
    UIView *stateBarbg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    stateBarbg.backgroundColor = RS_Theme_Color;
    [self.view addSubview:stateBarbg];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context[@"RS_APP"] = self;
}

#pragma mark NavtiveJSExport
- (void)hideTitleBar
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)close
{
    [self.navigationController popViewControllerAnimated:YES];
}

//微信支付
-(void)payWeChat:(NSDictionary *)param
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [param valueForKey:@"partnerId"];
    request.prepayId= [param valueForKey:@"prepayId"];
    request.package = [param valueForKey:@"package"];
    request.nonceStr= [param valueForKey:@"nonceStr"];
    request.timeStamp= [[param valueForKey:@"timeStamp"] toInt32];
    request.sign= [param valueForKey:@"sign"];
    [WXApi sendReq:request];
}

-(void)payAli:(NSString *)str
{
    RSAlertView *alertView = [[RSAlertView alloc]initWithTile:@"提示" msg:@"暂未提供该服务" leftButtonTitle:@"我知道啦" AndLeftBlock:^{
        
    }];
    [alertView show];
}

@end
