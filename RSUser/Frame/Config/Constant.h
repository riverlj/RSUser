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
#define  REDSCARF_BASE_URL @"http://jianzhi.honglingjinclub.com"
#define REDSCARF_PAY_URL @""
#define REDSCARF_MOBILE_URL @""
#endif

//APP请求超时时间
#define APPREQUESTTIMEOUT 5
//微信登陆
#define WEIXIN_LOGIN_SCOPE @""
#define WEIXIN_LOGIN_STATUS @""
#define WEIXIN_LOGIN_APPID @""
#define WEIXIN_LOGIN_SECRET @""
#define WEIXIN_LOGIN_

#endif /* Constant_h */
