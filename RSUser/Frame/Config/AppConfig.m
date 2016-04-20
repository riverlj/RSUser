//
//  AppConfig.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AppConfig.h"
#import "CYLTabBarController.h"

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
    [[UIBarButtonItem appearance] setTintColor:RS_TabBar_count_Color];

    //tabBar样式
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RS_TabBar_Title_Color,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RS_Theme_Color, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    UIImage *image = [UIImage imageFromColor:RS_Line_Color forSize:CGSizeMake(SCREEN_WIDTH, 1) withCornerRadius:0];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:image];
    
    //光标颜色
    [[UITextField appearance] setTintColor:RS_Line_Color];

}

+ (AppDelegate *)getAPPDelegate
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return delegate;
}

+ (NSMutableArray *)getLocationCartDataByCommityId:(NSString *)communtityId
{
    
    return nil;
}

@end
