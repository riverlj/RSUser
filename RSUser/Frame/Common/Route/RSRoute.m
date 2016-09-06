//
//  RSRouteController.m
//  RedScarf
//
//  Created by lishipeng on 16/1/6.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSRoute.h"
#import "AppDelegate.h"
#import "RSWebViewController.h"

static RSRoute *shareRSRoute = nil;
static  NSString *const k_route_controller_name = @"webview";
static  NSString *const k_route_method_name = @"action";
NSString *const RSRoute_SCheme = @"rsuser";

@implementation RSRoute
{
    NSMutableDictionary *routeDic;
}

+ (id)shareRSRoute {
    if (shareRSRoute) {
        return shareRSRoute;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareRSRoute = [[self alloc] init];
    });
    return shareRSRoute;
}

+ (id)routeWithURL:(NSURL *)parseURL {
    RSRoute *route = [RSRoute shareRSRoute];
    route.parseURL = parseURL;
    [route initPropertys];
    return route;
}

- (void)initPropertys {
    if (!self.parseURL) {
        self.urlstr = nil;
        self.scheme = nil;
        self.host = nil;
        self.path = nil;
        self.port = nil;
        self.fragment = nil;
        self.params = [NSMutableDictionary dictionary];
    }else {
        self.urlstr = self.parseURL.absoluteString;
        NSDictionary *dic = [self.urlstr parseUrl];
        self.scheme = self.parseURL.scheme;
        self.host = self.parseURL.host;
        self.path = [self.parseURL.path substringFromIndex:1];
        self.port = self.parseURL.port;
        NSArray *array = [self.urlstr componentsSeparatedByString:@"?"];
        if (array.count>1) {
            self.fragment = array[1];
        }else {
            self.fragment = nil;
        }
        self.params = [[dic valueForKey:@"params"] mutableCopy];
    }
}




-(NSMutableDictionary *) getObjectByName:(NSString *)name
{
    NSMutableDictionary *dic;
    if([routeDic valueForKey:name]) {
        dic = [routeDic valueForKey:name];
    } else {
        dic = [NSMutableDictionary dictionary];
    }
    return dic;
}

-(void) setValueByName:(NSString *)name key:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    [dic setObject:value forKey:key];
    [routeDic setObject:dic forKey:name];
}

//注册vc
-(void) register:(NSString *)name vcName:(NSString *)vcName
{
    [self setValueByName:name key:@"vcName" value:vcName];
}

-(UIViewController *) getVcByName:(NSString *)name
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    NSString *vcName = @"";
    if(![dic valueForKey:@"vcName"]) {
        vcName = [[name capitalizedString] append:@"ViewController"];
    } else {
        vcName = [dic valueForKey:@"vcName"];
    }
    if(NSClassFromString(vcName)) {
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        return vc;
    }
    return nil;
}

//获取当前的viewController
+(UIViewController *) superViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

//跳转到某一个path
-(void) redirectTo:(NSString *)path animation:(BOOL)animation
{
    NSDictionary *dict = [path parseURLParams];
    NSString *pathName = [dict objectForKey:@"path"];
    NSString *protocol = [dict valueForKey:@"protocol"];
    UIViewController *view = [RSRoute superViewController];
    if([protocol isEqualToString:@"http"] || [protocol isEqualToString:@"https"]) {
        RSWebViewController *webview = [[RSWebViewController alloc] init];
        if(view.tabBarController && view.navigationController) {
            [view.navigationController pushViewController:webview animated:animation];
        } else {
            [view presentViewController:webview animated:animation completion:^{}];
        }
        return;
    }
    NSArray *pagramArray = [pathName componentsSeparatedByString:@"/"];
    if(view.tabBarController) {
        if([self isMenu:(pagramArray[0])]) {
            [view.tabBarController setSelectedIndex:[self menuIndex:pagramArray[0]]];
        }
        if(![self isMenu:[pagramArray objectAtIndex:[pagramArray count]]]) {
            UIViewController *redirectVc =  [self getVcByName:[pagramArray objectAtIndex:[pagramArray count]]];
            [view.navigationController pushViewController:redirectVc animated:animation];
        }
    } else {
        UIViewController *redirectVc = [self getVcByName:[pagramArray objectAtIndex:[pagramArray count]]];
        if(redirectVc) {
            [view presentViewController:redirectVc animated:animation completion:^{
            }];
        }
    }
}

-(BOOL) isMenu:(NSString *)name
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    if([[dic valueForKey:@"isMenu"] boolValue]) {
        return YES;
    }
    return NO;
}

-(NSInteger) menuIndex:(NSString *)name
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    if([dic valueForKey:@"menuIndex"]) {
        return [[dic valueForKey:@"menuIndex"] integerValue];
    }
    return 0;
}

+(id)getViewControllerByHost:(NSString *)host
{
    NSString *vcName = [[host capitalizedString] append:@"ViewController"];
    if(NSClassFromString(vcName)) {
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        return vc;
    }
    return nil;
}

+(id)getViewControllerByPath:(NSString *)url
{
    NSDictionary *dic = [url parseUrl];
    NSDictionary *params = [dic valueForKey:@"params"];
    NSString *path = [dic valueForKey:@"path"];
    if (path.length != 0)
    {
        path = [NSString firstLetterCapital:path];
        UIViewController *vc = (UIViewController *)[[NSClassFromString([path append:@"ViewController"]) alloc]init];
        NSArray *keys = [params allKeys];
        for (int i=0; i<keys.count; i++)
        {
            NSString *key = keys[i];
            NSString *value = [params valueForKey:key];
            
            if ([value isPureInt]) {
                NSInteger intvalue = [value integerValue];
                [vc setValue:@(intvalue) forKey:key];
                continue;
            }
            if ([value isPureFloat]) {
                CGFloat floatValue = [value floatValue];
                [vc setValue:@(floatValue) forKey:key];
                continue;
            }
            
            [vc setValue:value forKey:key];
        }
        
        return vc;
    }
    return nil;
}

/**
 *  webview内部调用native方法
 *  @param target  来自哪个对象
 */
- (void)actionMethodFromTarget:(id)target {
    if (![self.scheme isEqualToString:RSRoute_SCheme]) {
        return;
    }
    
    //类名处理
    id finalTarget = nil;
    if ([self.host isEqualToString:k_route_controller_name]) { //webview内部跳转
        finalTarget = target;
    }else { //页面跳转
        Class targetClass = NSClassFromString([AppConfig findControllerNameByHost:self.host]);
        finalTarget = [[targetClass alloc] init];
    }
    
    //方法名处理
    SEL action = nil;
    NSString *actionString = nil;
    if (![self.path isEqualToString:k_route_method_name]) {  //webView内部调用本地方法
        if (self.params.count > 0) {
            actionString = [NSString stringWithFormat:@"%@:", self.path];
        }else { //页面跳转
            actionString = [NSString stringWithFormat:@"%@", self.path];
        }
        action = NSSelectorFromString(actionString);
    }else {
        action = nil;
    }
    
    if (self.params.count>0) {
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:action withObject:self.params];
        }else {
            [[RSToastView shareRSToastView] showToast:@"努力更新中，试试其他功能吧~"];
        }
        
    }else {
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:action];
        }else {
            [[RSToastView shareRSToastView] showToast:@"努力更新中，试试其他功能吧~"];
        }
    }
}

@end
