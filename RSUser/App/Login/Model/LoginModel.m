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

    [RSHttp requestWithURL:@"/weixin/login" params:params httpMethod:@"POSTJSON" success:^(NSDictionary* data) {
        [NSUserDefaults  setValue:[data valueForKey:@"token"] forKey:@"token"];
        [[RSToastView  shareRSAlertView]showToast:@"登陆成功"];
        [[AppConfig getAPPDelegate].crrentNavCtl popToRootViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView  shareRSAlertView]showToast:errmsg];
    }];
}

/**
 *  微信登陆获取Code
 */
+(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = WEIXIN_LOGIN_SCOPE;
    req.state = WEIXIN_LOGIN_STATUS ;
    [WXApi sendReq:req];
}

/**
 * 微信登陆获取token
 *
 *  @param code
 */
+(void)getAccess_token:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WEIXIN_LOGIN_APPID,WEIXIN_LOGIN_SECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //微信登陆
                [LoginModel weixinLogin:dic];
                
            }
        });
    });
}

@end
