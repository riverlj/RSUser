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
            @"vcUrl":@"home"
        },
        @{
            @"title":@"订单",
            @"normalIcon":@"tab_order_normal",
            @"selectedIcon":@"tab_order_selected",
            @"vcUrl":@"order"
        },
        @{
            @"title":@"我的",
            @"normalIcon":@"tab_person_normal",
            @"selectedIcon":@"tab_person_selected",
            @"vcUrl":@"Profile"
        }
    ];
    return tabBars;
}
@end
