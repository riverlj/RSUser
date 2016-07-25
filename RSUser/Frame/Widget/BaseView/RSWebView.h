//
//  RSWebView.h
//  RedScarf
//
//  Created by lishipeng on 15/12/16.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TSWebViewDelegate <UIWebViewDelegate>

@optional

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx;

@end

@interface RSWebView : UIWebView

@end