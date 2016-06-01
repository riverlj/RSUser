//
//  LoginModel.m
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LoginModel.h"
#import "CartModel.h"
#import "CodesView.h"

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

    [RSHttp requestWithURL:@"/user/weixinlogin" params:params httpMethod:@"POSTJSON" success:^(NSDictionary* data) {
        [NSUserDefaults  setValue:[data valueForKey:@"token"] forKey:@"token"];
        [[RSToastView  shareRSToastView]showToast:@"登陆成功"];
        [[AppConfig getAPPDelegate].crrentNavCtl popViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView  shareRSToastView]showToast:errmsg];
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

- (void)sendSiteCodeWithMobile:(NSNumber *)mobile
{
    NSDictionary *params = @{
                             @"mobile" : mobile
                             };
    [RSHttp requestWithURL:@"/site/code" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSToastView] showToast:@"发送成功"];
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

/**
 *  使用密码登陆
 *
 *  @param userName 用户名
 *  @param pwd      密码
 *  @param captcha  验证码
 */
- (void)loginbyPassword:(void (^)(void))success
{
    self.captcha = [NSUserDefaults getValue:@"captchaCode"];

    if (self.userName.length==0 ) {
        [[RSToastView shareRSToastView] showToast:@"用户名不能为空"];
        return;
    }
    
    if (self.passWord.length ==0) {
        [[RSToastView shareRSToastView] showToast:@"密码不能为空"];
        return;
    }
    
    if (self.captcha.length == 0) {
        self.captcha = @"";
    }
    
    NSDictionary *params = @{
                             @"username" : self.userName,
                             @"password" : self.passWord,
                             @"captcha" : self.captcha
                             };
    [[RSToastView shareRSToastView] showHUD:@""];
    [RSHttp requestWithURL:@"/user/passwordlogin" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSToastView] hidHUD];
        [NSUserDefaults setValue:[data valueForKey:@"token"] forKey:@"token"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

- (void)loginByMobileCode:(void (^)(void))success
{
    if (![self checkModel]) {
        return;
    }
    NSDictionary *params = @{
                             @"mobile" : self.userName,
                             @"code" : self.code,
                             @"captcha" : self.captcha
                             };
    [[RSToastView shareRSToastView] showHUD:@""];
    [RSHttp requestWithURL:@"/user/mobilelogin" params:params httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        [[RSToastView shareRSToastView] hidHUD];
        [NSUserDefaults setValue:[data valueForKey:@"token"] forKey:@"token"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];

}

- (void)sendCode:(void (^)(void))success
{
    if (![self checkModel]) {
        return;
    }
    
    NSDictionary *params = @{
                             @"mobile" : self.userName,
                             @"captcha" : self.captcha
                             };
    [[RSToastView shareRSToastView] showHUD:@""];
    [RSHttp requestWithURL:@"/site/code" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:@"发送成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];

}

- (void)bindMobile:(void (^)(void))success
{
    NSDictionary *params = @{
                             @"mobile" : self.userName,
                             @"code" : self.code
                             };
    [[RSToastView shareRSToastView] showHUD:@""];
    [RSHttp requestWithURL:@"/user/bindmobile" params:params httpMethod:@"POSTJSON" success:^(id data) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:@"绑定成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

- (BOOL)checkModel
{
    self.captcha = [NSUserDefaults getValue:@"captchaCode"];
    
    if (self.captcha.length == 0) {
        self.captcha = @"";
    }
    
    if (self.userName.length == 0) {
        [[RSToastView shareRSToastView] showToast:@"请输入手机号"];
        return NO;
    }
    if (![self.userName isMobile]) {
        [[RSToastView shareRSToastView] showToast:@"请输入正确的手机号"];
        return NO;
    }
    
    return YES;
}

@end
