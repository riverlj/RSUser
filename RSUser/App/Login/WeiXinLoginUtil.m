//
//  WeiXinLoginUtil.m
//  RSUser
//
//  Created by 李江 on 16/4/20.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "WeiXinLoginUtil.h"
#import "LoginModel.h"

@implementation WeiXinLoginUtil

+(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = WEIXIN_LOGIN_SCOPE;
    req.state = WEIXIN_LOGIN_STATUS ;
    [WXApi sendReq:req];
}

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
                NSError *error = nil;
                LoginModel *model = [MTLJSONAdapter modelOfClass:[LoginModel class] fromJSONDictionary:dic error:&error];
                NSDictionary *param = [model dictionaryValue];
                
                //微信登陆
                [LoginModel weixinLogin:param];
            }
        });
    });
}



@end
