//
//  RSTabBarControllerConfig.m
//  RSUser
//
//  Created by 李江 on 16/4/11.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTabBarControllerConfig.h"

@interface RSTabBarControllerConfig()<UITabBarControllerDelegate>

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
            nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2.5);
            vc.title = [tabBarItemsAttributes[i] valueForKey:CYLTabBarItemTitle];
            [array addObject:nav];
        }
                
        tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
        [tabBarController setViewControllers:array];
        
        _tabBarController = tabBarController;
        _tabBarController.delegate = self;
    }
    
    return _tabBarController;
}



-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        UIViewController *vc = nav.topViewController;
        NSString *str = NSStringFromClass([vc class]);
        if (![AppConfig getAPPDelegate].userValid) {
            if ([str isEqualToString:@"OrderViewController"] ||
                [str isEqualToString:@"ProfileViewController"]) {
                UIViewController *vc = [RSRoute getViewControllerByPath:@"RSUser://login"];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [[AppConfig getAPPDelegate].window.rootViewController presentViewController:nav animated:YES completion:nil];
                return NO;
            }
        }
        
    }
    
    return YES;
}


@end
