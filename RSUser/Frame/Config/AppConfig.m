//
//  AppConfig.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AppConfig.h"
#import "CYLTabBarController.h"
#import "LoginViewController.h"
#import "BandleCellPhoneViewController.h"
#import "CartModel.h"
#import <JSPatch/JSPatch.h>

@implementation AppConfig
+(NSDictionary *)tabBarConfig
{
    NSArray *hosts = @[@"home", @"order", @"Profile"];
    NSArray *tabBars = @[
                            @{
                             CYLTabBarItemTitle : @"首页",
                             CYLTabBarItemImage : @"tab_home_normal",
                             CYLTabBarItemSelectedImage : @"tab_home_selected",
                             },
                            @{
                             CYLTabBarItemTitle : @"订单",
                             CYLTabBarItemImage : @"tab_order_normal",
                             CYLTabBarItemSelectedImage : @"tab_order_selected",
                             },
                            @{
                             CYLTabBarItemTitle : @"我的",
                             CYLTabBarItemImage : @"tab_person_normal",
                             CYLTabBarItemSelectedImage : @"tab_person_selected",
                             }
                         ];
    
    NSDictionary *dic = @{
                          @"tabBarItemsAttributes":tabBars,
                          @"viewControllers": hosts
                         };
    return dic;
}

+ (void)customsizeInterface
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //导航样式
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont boldSystemFontOfSize:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBackgroundColor:RS_Theme_Color];
    [[UIBarButtonItem appearance] setTintColor:RS_COLOR_C7];

    //tabBar样式
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RS_COLOR_C3,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RS_Theme_Color, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    UIImage *image = [UIImage imageFromColor:RS_Line_Color forSize:CGSizeMake(SCREEN_WIDTH, 1) withCornerRadius:0];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:image];
    
    //光标颜色
    [[UITextField appearance] setTintColor:RS_Line_Color];

}

+ (void)setUserAgent
{
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@ RSUserAPP/%@",
                    userAgent,
                    [UIDevice clientVersion]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}



+(void)baiduMobStat
{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    [statTracker startWithAppId:RSUSER_BAIDU_KEY];
    statTracker.shortAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    statTracker.enableExceptionLog = YES; //截获崩溃信息
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;
    statTracker.logSendInterval = 1;
    statTracker.channelId = [UIDevice utm_source];
    statTracker.logSendWifiOnly = NO;
    statTracker.sessionResumeInterval = 60;
    statTracker.shortAppVersion = [UIDevice clientVersion];
}

+ (void)configJSPatch
{
//    [JSPatch testScriptInBundle];
    [JSPatch startWithAppKey:RSUSER_JSPATCH_KEY];
    [JSPatch sync];
}


+ (AppDelegate *)getAPPDelegate
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate;
}

+(void)switchViewControllerWithCode:(NSInteger)code
{
    UIViewController *vc;
    switch (code) {
        case 401:{
            [NSUserDefaults clearValueForKey:@"token"];
            vc = [[LoginViewController alloc]init];
            [[AppConfig getAPPDelegate].crrentNavCtl presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
            break;
        }
        case 403:{
            
            vc = [[BandleCellPhoneViewController alloc]init];
            [[AppConfig getAPPDelegate].crrentNavCtl presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

+ (void)checkToken {
    [RSHttp requestWithURL:@"/site/checktoken" params:nil httpMethod:@"GET" success:^(id data) {
        NSDictionary *dic = (NSDictionary *)data;
        BOOL valid = [[dic valueForKey:@"valid"] boolValue];
        [AppConfig getAPPDelegate].userValid = valid;
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}


+ (NSString *)findControllerNameByHost:(NSString *)host {
    NSString *controllerName = @"HomeViewController";
    NSDictionary *dic = @{
                          @"orderlist" : @"OrderViewController",
                          @"account" : @"ProfileViewController",
                          @"gooddetail" : @"GoodinfoViewController",
                          @"orderdetail" : @"OrderInfoViewController",
                          @"brandlist" : @"ChannelbrandsViewController",
                          @"brandinfo" : @"BrandinfoViewController"
                          };
    
    NSString *tempControllerName = [dic valueForKey:controllerName];
    if (tempControllerName.length>0) {
        controllerName = tempControllerName;
    }
    
    return controllerName;
}

+(CGFloat)adapterDeviceHeight:(CGFloat)number {
    if(iPhone6Plus)
    {
        return number*1.5;
    }
    else
    {
        return number;
    }
}

@end
