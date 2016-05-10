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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    _cartViewVc = [[CartViewController alloc]init];
    _location =  [[RSLocation alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_location.locationManager requestWhenInUseAuthorization];
    }
    [_location startLocation];
    [self configThreeLib];
    [self setUserAgent];
    
    self.window.rootViewController = [[LaunchimageViewController alloc]init];
    
   // [self setappRootViewControler];
    
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

#pragma 微信返回数据
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
            {
                //TODO 跳转到订单详情页面
                [self setappRootViewControler];
                self.tabBarControllerConfig.tabBarController.selectedIndex = 1;
                [[RSToastView shareRSToastView] showToast:@"支付成功"];
                break;
            }
            case WXErrCodeUserCancel:  //用户取消并返回
            {
                RSAlertView *alertView = [[RSAlertView alloc]initWithTile:@"温馨提示" msg:@"支付未完成,请重新支付" leftButtonTitle:@"我知道了" AndLeftBlock:^{
                    
                }];
                [alertView show];
                
                break;
            }
                
            default: //其他类型的错误
            {
                [self setappRootViewControler];
                self.tabBarControllerConfig.tabBarController.selectedIndex = 1;
                [[RSToastView shareRSToastView] showToast:@"支付失败，请重新支付"];
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
