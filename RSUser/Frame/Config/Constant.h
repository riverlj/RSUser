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
#define  REDSCARF_BASE_URL @"http://test2.dev.honglingjinclub.com"
#define REDSCARF_PAY_URL @""
#define REDSCARF_MOBILE_URL @"http://test2.dev.honglingjinclub.com"
#define APP_REGISTER_URL @"http://test2.dev.honglingjinclub.com/web/register.html"
#define APP_RESETPWD_URL @"http://test2.dev.honglingjinclub.com/web/resetPwd.html"

#define APP_CHANNEL_BASE_URL @"http://test2.dev.honglingjinclub.com/web/index.html#"
#else
//正式
#define  REDSCARF_BASE_URL @"http://waimai.honglingjinclub.com"
#define  REDSCARF_PAY_URL @""
#define  REDSCARF_MOBILE_URL @"http://waimai.honglingjinclub.com"
#define APP_REGISTER_URL @"http://waimai.honglingjinclub.com/web/register.html"
#define APP_RESETPWD_URL @"http://waimai.honglingjinclub.com/web/resetPwd.html"

#define APP_CHANNEL_BASE_URL @"http://waimai.honglingjinclub.com/web/index.html#"

#endif

//#ifdef DEBUG
//#   define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#   define NSLog(...)
//#endif

#define iPhone4S ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)
#define iPhone5S ([UIScreen mainScreen].bounds.size.height == 568 ? YES : NO)
#define iPhone6  ([UIScreen mainScreen].bounds.size.height == 667 ? YES : NO)
#define iPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736 ? YES : NO)

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0f ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0f ? YES : NO)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0f ? YES : NO)

//APP请求超时时间
#define APPREQUESTTIMEOUT 5
//微信登陆
#define WEIXIN_LOGIN_SCOPE @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
#define WEIXIN_LOGIN_STATUS @"demochenshujuan"
#define WEIXIN_LOGIN_APPID @"wx3ba861f7b4956067"
#define WEIXIN_LOGIN_SECRET @"d4624c36b6795d1d99dcf0547af5443d"

//JSPatch 热更新
#define RSUSER_JSPATCH_KEY @"ec064665c804cea3"

//百度统计key
#define RSUSER_BAIDU_KEY @"43a650796d"

#endif /* Constant_h */
