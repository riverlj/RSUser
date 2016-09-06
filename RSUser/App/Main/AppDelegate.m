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
#import "UMSocialWechatHandler.h"
#import "XHCustomShareView.h"

@interface AppDelegate (){
    NSString *updateUrl;
}
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
    
    [self UpdateVersion];
    self.window.rootViewController = [[LaunchimageViewController alloc]init];
    
    [AppConfig setUserAgent];
    [AppConfig customsizeInterface];

    [self.window makeKeyAndVisible];
    return YES;
}

-(void)UpdateVersion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [RSHttp mobileRequestWithURL:@"/mobile/version/" params:params httpMethod:@"GET" success:^(NSDictionary *dic) {
        NSString *content = [dic valueForKey:@"content"];
        updateUrl = [dic valueForKey:@"url"];
        if ([[dic valueForKey:@"forceUpdate"] boolValue]) {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
            [alert show];
        } else {
            if([[dic valueForKey:@"showUpdate"] boolValue]) {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
                [alert show];
            }
        }
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",APPID_IN_APPSTORE];

    if (buttonIndex==0) {
        updateUrl = url;
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:updateUrl]];
    }
}

-(void)configThreeLib
{
    [WXApi registerApp:WEIXIN_LOGIN_APPID];
    [AppConfig baiduMobStat];
    [AppConfig configJSPatch];
    [UMSocialData setAppKey:UMSOCIAL_APPKEY];
    [UMSocialWechatHandler setWXAppId:WEIXIN_LOGIN_APPID appSecret:WEIXIN_LOGIN_SECRET url:@"http://honglingjinclub.com"];
}

- (void)setappRootViewControler
{
    _tabBarControllerConfig = [[RSTabBarControllerConfig alloc] init];
    [self.window setRootViewController:_tabBarControllerConfig.tabBarController];
}



#pragma mark UIApplicationDelegate 代理方法
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([url.scheme isEqualToString:SCHEME_WEIXIN]) {
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
    if ([url.scheme isEqualToString:SCHEME_WEIXIN]) {
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

- (void)handleALIPayResult:(NSDictionary *)resultDic
{

    NSInteger resultStatus = [[resultDic valueForKey:@"resultStatus"] integerValue];
    if (resultStatus == 9000)
    {
        [[RSToastView shareRSToastView] showToast:@"支付成功"];
        [self gotoOrderInfoViewController];
    }
    else
    {
        [[RSToastView shareRSToastView] showToast:@"支付未完成,请重新支付"];
    }
}

- (void)gotoOrderInfoViewController
{
    [self.crrentNavCtl popToRootViewControllerAnimated:NO];
    self.tabBarControllerConfig.tabBarController.selectedIndex = 1;
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
    
    if ([resp isKindOfClass:SendMessageToWXResp.class]) {
        SendMessageToWXResp *aresp = (SendMessageToWXResp *)resp;
        XHCustomShareView *shareView = [self.window viewWithTag:9876];
        [shareView dismissShareView];
        if (aresp.errCode == 0) {
            [[RSToastView shareRSToastView] showToast:@"分享成功"];
        }else{
            [[RSToastView shareRSToastView] showToast:@"分享失败"];
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
