//
//  LoginViewController.h
//  RSUser
//
//  Created by 李江 on 16/4/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginView.h"
#import "LoginModel.h"

@interface LoginViewController : BaseViewController
//登录类型 1. 用户名密码登录 2.手机号验证码登录， 默认为1
@property (nonatomic ,assign)NSInteger type;

@property (nonatomic ,strong)LoginView *loginView;
@property (nonatomic ,strong)LoginModel *loginModel;

@end
