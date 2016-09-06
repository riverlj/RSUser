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

extern NSString *const RSRoute_SCheme;
@interface RSRoute : NSObject

@property (nonatomic ,strong)NSURL *parseURL;   //url
@property (nonatomic ,strong)NSString *urlstr;  //url字符串格式
@property (nonatomic, copy)NSString *scheme;    //协议
@property (nonatomic, copy)NSString *host;  //  对应要跳转的Controller
@property (nonatomic, copy)NSNumber *port;  //  一般用不到
@property (nonatomic, copy)NSString *path;  // 对应于要调用的方法
@property (nonatomic, copy)NSString *fragment;//参数,字符串格式
@property (nonatomic ,strong)NSMutableDictionary *params; //参数，字典格式

@property (nonatomic, copy)NSString *url;   //要分析的URL

+ (id)shareRSRoute;
+ (id)routeWithURL:(NSURL *)parseURL;
+(id)getViewControllerByHost:(NSString *)host;
+(id)getViewControllerByPath:(NSString *)path;

-(void)register:(NSString *)name vcName:(NSString *)vcName;
- (void)actionMethodFromTarget:(id)target;
@end
