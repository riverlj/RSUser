//
//  AppHeader.h
//  RSUser
//
//  Created by 李江 on 16/4/7.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#ifndef AppHeader_h
#define AppHeader_h

#ifdef DEBUG
#define  REDSCARF_BASE_URL @"http://test.jianzhi.honglingjinclub.com"
#define  REDSCARF_PAY_URL @"http://paytest.honglingjinclub.com"
#define  REDSCARF_MOBILE_URL @"http://lsp.dev.honglingjinclub.com"
#else
//正式
#define  REDSCARF_BASE_URL @"http://jianzhi.honglingjinclub.com"
#define  REDSCARF_PAY_URL @"https://pay.honglingjinclub.com"
#define  REDSCARF_MOBILE_URL @"http://weixin.honglingjinclub.com"
#endif

#import "Theme.h"
#import "RSHttp.h"
#import "RSCategory.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ReactiveCocoa.h"
#import "NSString+Helper.h"
#import "UtilMacro.h"
#import "AppConfig.h"
#import "RSRoute.h"
#import "MBProgressHUD.h"
#import "RSAlertView.h"
#import <PureLayout/PureLayout.h>
#endif /* AppHeader_h */
