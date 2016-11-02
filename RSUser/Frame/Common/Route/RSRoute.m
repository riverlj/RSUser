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

//实例方法
static RSRoute *shareRSRoute = nil;
//如果host是webview则是内部内部调用方法
static  NSString *const k_route_controller_name = @"webview";
//如果path是action则是跳转到某一个界面
static  NSString *const k_route_method_name = @"action";

@implementation RSRoute
{
    NSMutableDictionary *routeDic;
}

/**
 *  单例
 */
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

/**
 *  实例化
 *
 *  @param parseURL 要解析的参数
 *
 *  @return 单例对象
 */
+ (id)routeWithURL:(NSURL *)parseURL {
    RSRoute *route = [RSRoute shareRSRoute];
    route.parseURL = parseURL;
    [route initPropertys];
    return route;
}

/**
 *  初始化参数
 */
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
        if (self.parseURL.path.length>0) {
            self.path = [self.parseURL.path substringFromIndex:1];
        }else {
            self.path = nil;
        }
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

- (void)skipToViewControllerWithModel:(RSRouteSkipViewControllerModel)model {
    switch (model) {
        case RSRouteSkipViewControllerPresent:
            [self presentViewController];
            break;
        case RSRouteSkipViewControllerDismiss:
            [self dismissViewController];
            break;
        case RSRouteSkipViewControllerPush:
            [self pushViewController];
            break;
        case RSRouteSkipViewControllerPop:
            [self popViewController];
            break;
        default:
            [[RSToastView shareRSToastView] showToast:@"跳转模式匹配错误，请检查"];
            break;
    }
}

- (void)presentViewController {
    UIViewController *vc = [self getViewController];
    [self setViewControllerParams:vc];
    [[self currentViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)dismissViewController {
    
}

- (void)pushViewController {
    UIViewController *vc = [self getViewController];
    [self setViewControllerParams:vc];
    UINavigationController *navVc = [self currentViewController].navigationController;
    if (navVc) {
        [navVc pushViewController:vc animated:YES];
    }else{
        [[RSToastView shareRSToastView] showToast:@"导航控制器为空，请检查"];
    }
}

- (void)popViewController {
    
}

/**
 *  获取ViewController
 *
 *  @return vc
 */
-(UIViewController *)getViewController {
    NSString *vcName = @"";
    UIViewController *vc = nil;
    vcName = [[self.host capitalizedString] append:@"ViewController"];
    
    if(!NSClassFromString(vcName)) {
        vcName = [AppConfig findControllerNameByHost:self.host];
    }
    
    vc = [[NSClassFromString(vcName) alloc] init];
    return vc;
}

/**
 *  设置ViewController的参数
 */
- (void)setViewControllerParams:(UIViewController *)vc {
    NSArray *keys = self.params.allKeys;
    for (int i=0; i<keys.count; i++) {
        NSString *key = keys[i];
        NSString *value = [self.params valueForKey:key];
        
        /**
         *  TODO 简单处理，假设所有的变量的类型都是字符串, 细节判断，runtime
         */
        [vc setValue:value forKey:key];
    }
}

/**
 *  获取window中顶层的ViewController
 */
- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
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
    if (![self.scheme isEqualToString:SCHEME_RSUSER]) {
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

#pragma mark 路由层整理
+(void)skipToViewController:(NSString *)viewControllerPath model:(RSRouteSkipViewControllerModel)model {
    //1. 解析viewControllerPath
    NSDictionary *result = [self parseViewControllerPath:viewControllerPath];
    if (!result) {
        //解析失败
        return;
    }
    
    UIViewController *vc = [self buildClassWithDic:result];
    if (!vc) {
        //获取vc失败
        return;
    }
    [self skipWithModel:model viewController:vc];
    
}

+(void)skipWithModel:(RSRouteSkipViewControllerModel)model viewController:(UIViewController *)vc{
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    switch (model) {
        case RSRouteSkipViewControllerPresent:{
            [[self topViewControllerWithRootViewController:rootVc] presentViewController:vc animated:YES completion:nil];
            break;
        }
        case RSRouteSkipViewControllerNavPresent:{
            [[self topViewControllerWithRootViewController:rootVc] presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
            break;
        }
        case RSRouteSkipViewControllerPush:{
            UINavigationController *nav = (UINavigationController *)[self getSeletedNavViewController:rootVc];
            if (nav) {
                [nav pushViewController:vc animated:YES];
            }
            break;
        }
        case RSRouteSkipViewControllerPop:{
            UINavigationController *nav = (UINavigationController *)[self getSeletedNavViewController:rootVc];
            if (nav) {
                [nav popViewControllerAnimated:YES];
            }
            break;
        }
        case RSRouteSkipViewControllerDismiss:{
            [[self topViewControllerWithRootViewController:rootVc] dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

+ (UIViewController *)getSeletedNavViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self getSeletedNavViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return navigationController;
    }else {
        return nil;
    }
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

+ (UIViewController *)buildClassWithDic:(NSDictionary *)dic {
    NSString *vcName = dic[@"host"];
    vcName = [[NSString firstLetterCapital:vcName] append:@"ViewController"];
    UIViewController *vc = nil;
    
    if(NSClassFromString(vcName)) {
        vc = [[NSClassFromString(vcName) alloc] init];
        NSDictionary *params = dic[@"params"];
        NSArray *keys = [params allKeys];
        for (NSString *key in keys) {
            [vc setValue:params[key] forKey:key];
        }
    }
    return vc;
}

+(NSDictionary *)parseViewControllerPath:(NSString *)viewControllerPath
{
    NSURL *url = [NSURL URLWithString:[viewControllerPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([url.scheme isEqualToString:@"rsuser"]) {
        NSString *path = @"";
        if (url.path.length>0) {
            path = [url.path substringWithRange:NSMakeRange(1, url.path.length)];
        }
        NSString *paramstr = nil;
        if (url.query.length > 0) {
            paramstr = url.query;
#pragma mark 中文处理
            paramstr = [paramstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSMutableDictionary *paramsDic = [NSMutableDictionary new];
        if (paramstr.length > 0) {
            NSArray *paramsArray =  [paramstr componentsSeparatedByString:@"&"];
            for (NSString *param in paramsArray) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if (elts.count < 2) continue;
                [paramsDic setValue:elts.lastObject forKey:elts.firstObject];
            }
        }
        
        NSDictionary *result = @{
                                 @"scheme" : url.scheme,
                                 @"host" : url.host,
                                 @"path" : path,
                                 @"params" : paramsDic
                                 };
        return result;
    }else {
        return nil;
    }
}

@end
