//
//  AppDelegate.h
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLocation.h"
#import "CartViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//地理位置
@property (nonatomic, strong)RSLocation *location;
//所有学校的购物车数据
@property (nonatomic, strong)NSMutableDictionary *allSchoolCartData;
//当前学校的购物车数据
@property (nonatomic, strong)NSMutableArray *localCartData;
//购物车VC
@property (nonatomic, strong)CartViewController *cartViewVc;

@end

