//
//  LoginView.h
//  RSUser
//
//  Created by 李江 on 16/6/2.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIScrollView
@property (nonatomic, strong)UITextField *userNameTextField;
@property (nonatomic, strong)UITextField *pwdTextField;
@property (nonatomic, strong)UIButton *forgetPwdButton;
@property (nonatomic, strong)UIButton *sendCodeButton;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UIButton *loginByCodeButton;
@property (nonatomic, strong)UIButton *loginByWeChatButton;

@property (nonatomic ,assign)NSInteger loginType;

@end
