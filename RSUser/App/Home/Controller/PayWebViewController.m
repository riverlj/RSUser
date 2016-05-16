//
//  PayWebViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/27.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "PayWebViewController.h"
#import "OrderInfoAndStatusViewController.h"

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
-(void)payWeChat:(id)param
{
    NSLog(@"%@", param);
    
    [NSUserDefaults setValue:self.orderId forKey:@"currentorderid"];
    
    NSData *data = [param dataUsingEncoding:NSUTF8StringEncoding];
     NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
     

    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [dic valueForKey:@"partnerid"];
    request.prepayId= [dic valueForKey:@"prepayid"];
    request.package = [dic valueForKey:@"package"];
    request.nonceStr= [dic valueForKey:@"noncestr"];
    request.timeStamp= [[dic valueForKey:@"timestamp"] intValue];
    request.sign= [dic valueForKey:@"sign"];
    
    [WXApi sendReq:request];
}

-(void)payAli:(NSString *)str
{
    [[RSToastView shareRSToastView] showToast:@"暂未提供该服务"];
}

- (void)backUp
{
    //订单详情页面
    OrderInfoAndStatusViewController *vc = [[OrderInfoAndStatusViewController alloc]init];
    vc.orderId = self.orderId;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController pushViewController:vc animated:NO];

}

@end
