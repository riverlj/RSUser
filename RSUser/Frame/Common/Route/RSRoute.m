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
        self.scheme = nil;
        self.host = nil;
        self.path = nil;
        self.port = nil;
        self.fragment = nil;
    }else {
        self.scheme = self.parseURL.scheme;
        self.host = self.parseURL.host;
        self.path = self.parseURL.host;
        self.port = self.parseURL.port;
        self.fragment = self.parseURL.parameterString;
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
 *  通过scheme调用本地方法
 */
- (void)parseURL:(NSURL *)url FromTarget:(id)target {
    NSDictionary *urlDic = [url.absoluteString parseUrl];
    if (!urlDic) {
        return;
    }
    
    NSString *protocol = nil;
    NSString *classname = nil;
    NSString *actionname = nil;
    NSDictionary *params = nil;
    
    protocol = [urlDic valueForKey:@"protocol"];
    if (![protocol isEqualToString:RSRoute_SCheme]) {
        return;
    }
    
    NSString *path = [urlDic valueForKey:@"path"];
    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    if (pathArray.count == 2) {
        classname = pathArray[0];   //类名
        actionname = pathArray[1];  //方法名
    }
    //参数
    params = [urlDic valueForKey:@"params"];
    
    //类名处理
    id finalTarget = nil;
    if ([classname isEqualToString:k_route_controller_name]) { //webview内部跳转
        finalTarget = target;
    }else { //页面跳转
        Class targetClass = NSClassFromString([AppConfig findControllerNameByHost:classname]);
        finalTarget = [[targetClass alloc] init];
    }
    
    //方法名处理
    SEL action = nil;
    NSString *actionString = nil;
    if (![actionname isEqualToString:k_route_method_name]) {  //webView内部调用本地方法
        if (params.count > 0) {
            actionString = [NSString stringWithFormat:@"%@:", actionname];
        }else { //页面跳转
            actionString = [NSString stringWithFormat:@"%@", actionname];
        }
        action = NSSelectorFromString(actionString);
    }else {
        action = nil;
    }
    
    if (params.count>0) {
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:action withObject:params];
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
