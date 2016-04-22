//
//  LoginModel.m
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LoginModel.h"
#import "CartModel.h"

@implementation LoginModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"type" : @"type",
             @"openid" : @"openid",
             @"access_token" : @"access_token",
             @"refresh_token" : @"refresh_token",
             @"expires_in" : @"expires_in"
             };
}

+(void)weixinLogin:(NSDictionary *)params
{
    [params setValue:@"weixin" forKey:@"type"];
    [RSHttp requestWithURL:@"/weixin/login" params:params httpMethod:@"POST" success:^(NSDictionary* data) {
        [NSUserDefaults  setValue:[data valueForKey:@"token"] forKey:@"token"];
        // 登陆成功之后下载远程购物车
        [CartModel downLoadCartsWithSuccess:nil];
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView  shareRSAlertView]showToast:errmsg];
    }];
}

@end
