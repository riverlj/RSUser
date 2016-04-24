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
{//wxfbb916a94b6b04b6://oauth?code=001pts8e0F2pNF15iWae0ZLs8e0pts84&state=rsuserf99054
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
        NSString *code = aresp.code;
        //请求token
        [WeiXinLoginUtil getAccess_token:code];
    }
}

@end
