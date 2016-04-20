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
    
    [self setRootViewControler];
    return YES;
}

- (void)setRootViewControler
{
    RSTabBarControllerConfig *tabBarControllerConfig = [[RSTabBarControllerConfig alloc] init];
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [AppConfig customsizeInterface];
    [self.window makeKeyAndVisible];
}

@end
