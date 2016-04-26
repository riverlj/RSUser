//
//  LoginModel.h
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface LoginModel : RSModel

@property (nonatomic, strong)NSString *type;
@property (nonatomic, assign)NSInteger openid;
@property (nonatomic, strong)NSString *access_token;
@property (nonatomic, strong)NSString *refresh_token;
@property (nonatomic, assign)NSInteger expires_in;
+(void)weixinLogin:(NSDictionary *)params;

+(void)sendAuthRequest;
+(void)getAccess_token:(NSString *)code;
@end