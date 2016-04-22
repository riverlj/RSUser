//
//  AppDelegate.h
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLocation.h"
#import "LocalCartManager.h"
#import "CartViewController.h"
#import "WXApi.h"
#import "SchoolModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
//地理位置
@property (nonatomic, strong)RSLocation *location;
//购物车VC
@property (nonatomic, strong)CartViewController *cartViewVc;
//当前购物车与学校
@property (nonatomic, strong)LocalCartManager *localCartManager;

//当前导航
@property (nonatomic, strong)UINavigationController *crrentNavCtl;

@property (nonatomic, strong)SchoolModel *schoolModel;

- (void)setRootViewController:(UIViewController *)rootVC;
@end