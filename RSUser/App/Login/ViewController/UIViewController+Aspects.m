//
//  UIViewController+Aspects.m
//  RSUser
//
//  Created by 李江 on 16/6/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "UIViewController+Aspects.h"
#import "Aspects.h"

@implementation UIViewController (Aspects)
+(void)load
{
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){
                                   
                                   UIViewController *vc = aspectInfo.instance;
                                    if([vc.navigationController.viewControllers count] > 1)
                                    {
                                        vc.tabBarController.tabBar.hidden = YES;
                                    }
                                    else
                                    {
                                        vc.tabBarController.tabBar.hidden = NO;
                                    }
                                   

    } error:NULL];
}

@end
