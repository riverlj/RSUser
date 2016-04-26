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
    
    [NSUserDefaults setValue:@"9e7de0614805535ab970d7fe74e6fca6c92483e54ba56e60a4ddc4db48cd8f10a%3A2%3A%7Bi%3A0%3Bs%3A5%3A%22token%22%3Bi%3A1%3Bs%3A49%3A%22%5B%2218%22%2C%22hDRfl1Mofvte6Baz_jKc5w5WJ7sMcG3U%22%2C2592000%5D%22%3B%7D" forKey:@"token"];
        
    _cartViewVc = [[CartViewController alloc]init];
    _location =  [[RSLocation alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_location.locationManager requestWhenInUseAuthorization];
    }
    [_location startLocation];
    [self configThreeLib];
    
    [self setappRootViewControler];
    return YES;
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
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        NSString *code = aresp.code;
        //请求token
        [LoginModel getAccess_token:code];
    }
}

@end
