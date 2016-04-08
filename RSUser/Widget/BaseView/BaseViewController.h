//
//  BaseViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "RSTipsView.h"

@interface BaseViewController : UIViewController
//该页面所要请求的网络地址
@property (nonatomic, copy)NSString *requestUrl;
@property (nonatomic, strong) RSTipsView *tips;
@end
