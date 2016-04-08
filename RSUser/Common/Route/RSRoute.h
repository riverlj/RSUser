//
//  RSRouteController.h
//  RedScarf
//
//  Created by lishipeng on 16/1/6.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 scheme://host:port/path?query#fragment
 */
@interface RSRoute : NSObject

@property (nonatomic, copy)NSString *url;   //要分析的URL
@property (nonatomic, copy)NSString *scheme;    //协议
@property (nonatomic, copy)NSString *host;  //  对应要跳转的Controller
@property (nonatomic, copy)NSString *port;  //  一般用不到
@property (nonatomic, copy)NSString *path;  //
@property (nonatomic, copy)NSString *fragment;//参数


-(void)register:(NSString *)name vcName:(NSString *)vcName;

+(id)getViewControllerByHost:(NSString *)host;

@end
