//
//  LoginModel.h
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSModel.h"

@interface LoginModel : RSModel
/**
 "access_token" = "OezXcEiiBSKSxW0eoylIeNfHZGXa4-u5bxA9f9tWND-JuWTBv-AFEBPbDXbE708-gYY25Zy3bI368qxzLJJws3Et5BH2YBZceQ7QPDgzAmYdY8s2pVC4MRzJGOs_Gc1sFTGX1tk3JUMXFOrrAv9pGQ";
 "expires_in" = 7200;
 openid = oY2bDsz11cc8vO4woFZ8kuh95r18;
 "refresh_token" = "OezXcEiiBSKSxW0eoylIeNfHZGXa4-u5bxA9f9tWND-JuWTBv-AFEBPbDXbE708-I_mUTfqEhnYHNZlVykYPFCN980dRYW5RPa946wfjNOQSF_fb_bbQe9KlIcTiYj_glSpiE-TGhrhxD6Hepy7pgg";
 scope = "snsapi_userinfo";
 unionid = "ozUO4wcAnulxHovEM_t8gMNQORE0";
 */
@property (nonatomic, strong)NSString *type;
@property (nonatomic, assign)NSInteger openid;
@property (nonatomic, strong)NSString *access_token;
@property (nonatomic, strong)NSString *refresh_token;
@property (nonatomic, assign)NSInteger expires_in;
+(void)weixinLogin:(NSDictionary *)params;
@end
