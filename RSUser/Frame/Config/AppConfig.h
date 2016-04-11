//
//  AppConfig.h
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <Foundation/Foundation.h>
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
@end
