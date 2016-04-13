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
@interface AppDelegate ()<CLLocationManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RSLocation *location = [[RSLocation alloc]init];
    _location = location;
    [location startLocation];
    
    RSTabBarControllerConfig *tabBarControllerConfig = [[RSTabBarControllerConfig alloc] init];
    [self.window setRootViewController:tabBarControllerConfig.tabBarController];
    [AppConfig customsizeInterface];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

@end
