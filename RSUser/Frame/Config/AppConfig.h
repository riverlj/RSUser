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
 *  设置webViewUserAgent
 */
+ (void)setUserAgent;

/**
 *  获取APPdelegate
 */
+ (AppDelegate *)getAPPDelegate;

/**
 *  根据Code返回切换视图
 *
 *  @param code 
 */
+(void)switchViewControllerWithCode:(NSInteger)code;

/**
 *  百度统计
 */
+(void)baiduMobStat;

/**
 *  JSPatch 热更新
 */
+ (void)configJSPatch;

/**
 *  检查token是否有效
 *
 *  @return
 */
+ (void)checkToken;

/**
 * 路由对照表
 *
 *  @param host
 *
 *  @return 类名
 */
+ (NSString *)findControllerNameByHost:(NSString *)host;

+(CGFloat)adapterDeviceHeight:(CGFloat)number;

+ (CGFloat)fontSizeScale;
@end
