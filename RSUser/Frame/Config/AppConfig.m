//
//  AppConfig.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
+(NSArray *)tabBarConfig
{
    NSArray *tabBars = @[
        @{
            @"title":@"首页",
            @"normalIcon":@"tab_home_normal",
            @"selectedIcon":@"tab_home_selected",
            @"host":@"home"
        },
        @{
            @"title":@"订单",
            @"normalIcon":@"tab_order_normal",
            @"selectedIcon":@"tab_order_selected",
            @"host":@"order"
        },
        @{
            @"title":@"我的",
            @"normalIcon":@"tab_person_normal",
            @"selectedIcon":@"tab_person_selected",
            @"host":@"Profile"
        }
    ];
    return tabBars;
}

+ (void)customsizeInterface
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-background"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont boldSystemFontOfSize:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBackgroundColor:RS_Theme_Color];
    [[UIBarButtonItem appearance] setTintColor:RS_TabBar_count_Color];
}
@end
