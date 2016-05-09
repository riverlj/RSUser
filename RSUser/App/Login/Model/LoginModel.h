//
//  LoginModel.h
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface LoginModel : RSModel

#pragma mark 微信登陆参数
@property (nonatomic, strong)NSString *type;
@property (nonatomic, assign)NSInteger openid;
@property (nonatomic, strong)NSString *access_token;
@property (nonatomic, strong)NSString *refresh_token;
@property (nonatomic, assign)NSInteger expires_in;


@property (nonatomic ,strong)NSString *userName;
@property (nonatomic ,strong)NSString *passWord;
/** 手机验证码*/
@property (nonatomic ,strong)NSString *code;
/** 图片验证码*/
@property (nonatomic ,strong)NSString *captcha;


+(void)weixinLogin:(NSDictionary *)params;
+(void)sendAuthRequest;
+(void)getAccess_token:(NSString *)code;

- (void)loginbyPassword:(void (^)(void))success;
- (void)loginByMobileCode:(void (^)(void))success;
- (void)sendCode:(void (^)(void))success;
/**
 * 绑定手机号
 *
 *  @param success 回调
 */
- (void)bindMobile:(void (^)(void))success;
@end
