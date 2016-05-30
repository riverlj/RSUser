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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configThreeLib];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = RS_Background_Color;

    _cartViewVc = [[CartViewController alloc]init];
    _location =  [[RSLocation alloc]init];
    [_location startLocation];
    
    [self setUserAgent];
    
    self.window.rootViewController = [[LaunchimageViewController alloc]init];
    
    [AppConfig customsizeInterface];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setUserAgent{
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"%@", userAgent);
    NSString *ua = [NSString stringWithFormat:@"%@ RSUserAPP/%@",
                        userAgent,
                         [UIDevice clientVersion]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}


-(void)configThreeLib
{
    [WXApi registerApp:WEIXIN_LOGIN_APPID];
    [AppConfig baiduMobStat];
    [AppConfig configJSPatch];
    
//    [JPEngine startEngine];
//    NSError *error = nil;
//    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"js"];
//    NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:&error];
//    [JPEngine evaluateScript:script];
    
}

- (void)setRootViewController:(UIViewController *)rootVC
{
    
    self.window.rootViewController = rootVC;
}

- (void)setappRootViewControler
{
    _tabBarControllerConfig = [[RSTabBarControllerConfig alloc] init];
    [self.window setRootViewController:_tabBarControllerConfig.tabBarController];
}

#pragma mark UIApplicationDelegate 代理方法
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
                NSString *orderid = [NSUserDefaults getValue:@"currentorderid"];
                [NSUserDefaults clearValueForKey:@"currentorderid"];
                UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://OrderInfoAndStatus?orderId=%@",orderid]];
                [self.crrentNavCtl pushViewController:vc animated:YES];
                
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
                NSString *orderid = [NSUserDefaults getValue:@"currentorderid"];
                [NSUserDefaults clearValueForKey:@"currentorderid"];
                UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://OrderInfoAndStatus?orderId=%@",orderid]];
                [self.crrentNavCtl pushViewController:vc animated:YES];
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

@end
