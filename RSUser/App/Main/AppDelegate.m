//
//  AppDelegate.m
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AppDelegate.h"
#import "RSCartButtion.h"
#import "LoginViewController.h"
#import "LoginModel.h"
#import "LaunchimageViewController.h"
#import <JSPatch/JPEngine.h>
#import "CustomNSURLProtocol.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AppConfig checkToken];
    [self configThreeLib];

    [NSURLProtocol registerClass:[CustomNSURLProtocol class]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = RS_Background_Color;

    _cartViewVc = [[CartViewController alloc]init];
    _location =  [[RSLocation alloc]init];
    [_location startLocation];
    
    
    self.window.rootViewController = [[LaunchimageViewController alloc]init];
    
    [AppConfig setUserAgent];
    [AppConfig customsizeInterface];

    [self.window makeKeyAndVisible];
    return YES;
}

-(void)configThreeLib
{
    [WXApi registerApp:WEIXIN_LOGIN_APPID];
    [AppConfig baiduMobStat];
    [AppConfig configJSPatch];
}

- (void)setappRootViewControler
{
    _tabBarControllerConfig = [[RSTabBarControllerConfig alloc] init];
    [self.window setRootViewController:_tabBarControllerConfig.tabBarController];
}



#pragma mark UIApplicationDelegate 代理方法
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:@"wx3ba861f7b4956067"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    __weak AppDelegate *selfB = self;
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [selfB handleALIPayResult:resultDic];
        }];
    }
    return YES;
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if ([url.scheme isEqualToString:@"wx3ba861f7b4956067"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        __weak AppDelegate *selfB = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%@", resultDic);
            [selfB handleALIPayResult:resultDic];
        }];
    }
    
    return YES;
}

- (void)handleALIPayResult:(NSDictionary *)resultDic {

    NSInteger resultStatus = [[resultDic valueForKey:@"resultStatus"] integerValue];
    if (resultStatus == 9000) {
        [[RSToastView shareRSToastView] showToast:@"支付成功"];
        [self gotoOrderInfoViewController];
    }else {
        [[RSToastView shareRSToastView] showToast:@"支付未完成,请重新支付"];
    }
    
}

- (void)gotoOrderInfoViewController {
    NSString *orderid = [NSUserDefaults getValue:@"currentorderid"];
    [NSUserDefaults clearValueForKey:@"currentorderid"];
    UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://OrderInfoAndStatus?orderId=%@",orderid]];
    [self.crrentNavCtl pushViewController:vc animated:YES];
}

#pragma mark WXApiDelegate 代理方法
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
            {
                [[RSToastView shareRSToastView] showToast:@"支付成功"];
                //跳转到订单详情
                [self gotoOrderInfoViewController];
                break;
            }
            case WXErrCodeUserCancel:  //用户取消并返回
            {
                [[RSToastView shareRSToastView] showToast:@"支付未完成,请重新支付"];
                break;
            }
                
            default: //其他类型的错误
            {
                [[RSToastView shareRSToastView] showToast:@"支付失败，请重新支付"];
                [self gotoOrderInfoViewController];
                break;
            }
        }
        return;
    }
    
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        //请求token
        [LoginModel getAccess_token:code];
    }
    
}

-(void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoodListChangedInOrderView" object:nil];
}

@end
