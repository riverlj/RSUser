//
//  PayWebViewController.h
//  RSUser
//
//  Created by 李江 on 16/4/27.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol NavtiveJSExport <JSExport>
- (void)close;
- (void)hideTitleBar;
- (void)payWeChat:(NSString *)str;
-(void)payAli:(NSString *)str;
@end

@interface PayWebViewController : RSWebViewController<NavtiveJSExport>
@property (strong, nonatomic) JSContext *context;
@end