//
//  PayWebViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/27.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "PayWebViewController.h"
#import "OrderInfoAndStatusViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PayWebViewController ()

@end

@implementation PayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择支付方式";
    self.navigationController.navigationBar.hidden = NO;
    self.bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20);
    
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

- (void)closeWebView
{
    [self backUp];
}

//微信支付
-(void)payWeChat:(id)param
{
    [self saveCreatOrderId];
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
     NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [dic valueForKey:@"partnerid"];
    request.prepayId= [dic valueForKey:@"prepayid"];
    request.package = [dic valueForKey:@"package"];
    request.nonceStr= [dic valueForKey:@"noncestr"];
    request.timeStamp= [[dic valueForKey:@"timestamp"] intValue];
    request.sign= [dic valueForKey:@"sign"];
    
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:request];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[RSToastView shareRSToastView] showToast:@"请先安装微信客户端"];
        });
    }
    
}

-(void)payAli:(id)str
{
    [self saveCreatOrderId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString *payData = [dic valueForKey:@"payData"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *appScheme = @"rsuser";
        [[AlipaySDK defaultService] payOrder:payData fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [[AppConfig getAPPDelegate] handleALIPayResult:resultDic];
        }];
    });
}

- (void)saveCreatOrderId {
    [NSUserDefaults setValue:self.orderId forKey:@"creatorderid"];
}

- (void)backUp
{
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
