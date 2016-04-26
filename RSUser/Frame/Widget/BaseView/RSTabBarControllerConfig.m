//
//  RSTabBarControllerConfig.m
//  RSUser
//
//  Created by 李江 on 16/4/11.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTabBarControllerConfig.h"

@interface RSTabBarControllerConfig()
@end

@implementation RSTabBarControllerConfig

- (CYLTabBarController *)tabBarController
{
    if (_tabBarController == nil) {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        CYLTabBarController *tabBarController = [[CYLTabBarController alloc] init];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
    
        NSDictionary *tabbars = [AppConfig tabBarConfig];
        NSArray *tabBarItemsAttributes = [tabbars valueForKey:@"tabBarItemsAttributes"];
        NSArray *hosts = [tabbars valueForKey:@"viewControllers"];
        
        for (int i=0; i< hosts.count; i++) {
            UIViewController *vc = [RSRoute getViewControllerByHost:hosts[i]];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            vc.title = [tabBarItemsAttributes[i] valueForKey:CYLTabBarItemTitle];
            [array addObject:nav];
        }
                
        tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
        [tabBarController setViewControllers:array];
        
        _tabBarController = tabBarController;
        
    }
    
    return _tabBarController;
}

@end
