//
//  RSJSWebViewController.h
//  RSUser
//
//  Created by 李江 on 16/5/6.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSWebViewController.h"

@protocol RS_APP <JSExport>
-(void) closeWebView;
-(NSString *)getTokenFromNative;
-(void)setNativeTokenInWeb:(NSString *)token;
- (void)takePhoneByNative;
- (void)setNavTitle:(NSString *)title;
- (void)loginByNative;

@end

@interface RSJSWebViewController : RSWebViewController<RS_APP>
@property (strong, nonatomic) JSContext *context;

@end
