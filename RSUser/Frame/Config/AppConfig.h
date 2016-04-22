//
//  AppConfig.h
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@class CYLTabBarController;

@interface AppConfig : NSObject
/**
 *  tabBar数据源
 *
 *  @return 数据源字典
 */
+(NSDictionary *)tabBarConfig;
/**
 *  app样式设置
 */
+ (void)customsizeInterface;

/**
 *  获取APPdelegate
 */
+ (AppDelegate *)getAPPDelegate;

/**
 * 获取当前学校的购物车数据
 */
+ (NSMutableArray *)getLocalCartData;

/**
 *
 *
 *  @return  [{"id":1, @"num":2},{"id":1, @"num":2}]
 */
+ (NSArray *)filterLocalCartData;
/**
 *  保存数据到学校
 */
+ (void)saveLocalCartData;

/**
 *  根据Code返回切换视图
 *
 *  @param code 
 */
+(void)setRootViewControllerWithCode:(NSInteger)code;

+ (void)saveCartMerge;
+ (NSInteger)getCartMerge;
@end
