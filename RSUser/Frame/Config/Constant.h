//
//  Constant.h
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#ifdef DEBUG
#define  REDSCARF_BASE_URL @"http://test.dev.honglingjinclub.com"
#define REDSCARF_PAY_URL @""
#define REDSCARF_MOBILE_URL @""
#else
#define  REDSCARF_BASE_URL @"http://weixin.honglingjinclub.com"
#define REDSCARF_PAY_URL @""
#define REDSCARF_MOBILE_URL @""
#endif

#define iPhone4S ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)
#define iPhone5S ([UIScreen mainScreen].bounds.size.height == 568 ? YES : NO)
#define iPhone6  ([UIScreen mainScreen].bounds.size.height == 667 ? YES : NO)
#define iPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736 ? YES : NO)

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0f ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0f ? YES : NO)

//APP请求超时时间
#define APPREQUESTTIMEOUT 5
//微信登陆
#define WEIXIN_LOGIN_SCOPE @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
#define WEIXIN_LOGIN_STATUS @"demochenshujuan"
#define WEIXIN_LOGIN_APPID @"wx3ba861f7b4956067"
#define WEIXIN_LOGIN_SECRET @"d4624c36b6795d1d99dcf0547af5443d"

#define APP_REGISTER_URL @"http://mxj.dev.honglingjinclub.com/register.html"
#define APP_RESETPWD_URL @"http://mxj.dev.honglingjinclub.com/resetPwd.html"

#endif /* Constant_h */
