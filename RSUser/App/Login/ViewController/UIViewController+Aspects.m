//
//  UIViewController+Aspects.m
//  RSUser
//
//  Created by 李江 on 16/6/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "UIViewController+Aspects.h"
#import "Aspects.h"

static char const * const ObjectTagKey = "ObjectTag";

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
                                        vc.hasBackBtn = YES;
                                    }
                                    else
                                    {
                                        vc.tabBarController.tabBar.hidden = NO;
                                        vc.hasBackBtn = NO;
                                    }
                                   
                                   [vc setBackUpBtn];

    } error:NULL];
}

- (void) setHasBackBtn:(Boolean)hasBackBtn
{
    NSNumber *number = [NSNumber numberWithBool: hasBackBtn];
    objc_setAssociatedObject(self, ObjectTagKey, number , OBJC_ASSOCIATION_RETAIN);
}
-(Boolean)hasBackBtn
{
    NSNumber *number = objc_getAssociatedObject(self, ObjectTagKey);
    return [number boolValue];
}

- (void)setBackUpBtn
{
    if (self.hasBackBtn)
    {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        iv.image = [UIImage imageNamed:@"nav-goback"];
        [iv addTapAction:@selector(backUp) target:self];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:iv];
        self.navigationItem.leftBarButtonItem = item;
        
    }
}

- (void)backUp
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
