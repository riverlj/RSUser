//
//  AppDelegate.m
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AppDelegate.h"
#import "RSTabBarControllerConfig.h"
#import "RSCartButtion.h"
#import "LoginViewController.h"
#import "LoginModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    _cartViewVc = [[CartViewController alloc]init];
    _location =  [[RSLocation alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_location.locationManager requestWhenInUseAuthorization];
    }
    [_location startLocation];
    [self configThreeLib];
    
    [self setappRootViewControler];
    
    [self setUserAgent];
    return YES;
}

- (void)setUserAgent{
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"%@", userAgent);
    NSString *ua = [NSString stringWithFormat:@"%@ HLJUserAPP/%@",
                        userAgent,
                         [UIDevice clientVersion]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}

-(void)configThreeLib
{
    [WXApi registerApp:WEIXIN_LOGIN_APPID withDescription:@"weixin"];
}

- (void)setRootViewController:(UIViewController *)rootVC
{
    
    self.window.rootViewController = rootVC;
}

- (void)setappRootViewControler
{
    RSTabBarControllerConfig *tabBarControllerConfig = [[RSTabBarControllerConfig alloc] init];
        [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [AppConfig customsizeInterface];
    [self.window makeKeyAndVisible];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

#pragma 微信登陆返回数据
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                NSLog(@"支付成功"); //服务器端查询支付通知或查询API返回的结果再提示成功
                //TODO 跳转到订单详情页面
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                //TODO跳转到订单详情页
                break;
        }
    }
    
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        //请求token
        [LoginModel getAccess_token:code];
    }
}

@end
