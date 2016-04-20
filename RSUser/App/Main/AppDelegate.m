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
#import "WeiXinLoginUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _localCartManager = [LocalCartManager shareLocalCartManager];
    
    _cartViewVc = [[CartViewController alloc]init];
    _location =  [[RSLocation alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_location.locationManager requestWhenInUseAuthorization];
    }
    [_location startLocation];
    
    [self setappRootViewControler];
    return YES;
}

-(void)configThreeLib
{
    [WXApi registerApp:@""];
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

-(void) onReq:(BaseReq*)req
{

}

-(void) onResp:(BaseResp*)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode== 0) {
        //TODO 获取CODE
        NSString *code = aresp.code;
        //TODO 根据CODE去获取TOKEN
        
        [WeiXinLoginUtil getAccess_token:code];
    }
}


@end
