//
//  LoginView.m
//  RSUser
//
//  Created by 李江 on 16/6/2.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LoginView.h"
#import "UITextField+RSAdd.h"

@interface LoginView ()
{
    UIView *contentView;
}
@property (nonatomic, strong)UIImageView *userIconImageView;
@property (nonatomic, strong)UIImageView *pwdIconImageView;
@property (nonatomic, strong)UIImageView *logoImageView;



@end

@implementation LoginView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.logoImageView];
        [self addSubview:self.userNameTextField];
        [self addSubview:self.pwdTextField];
        [self addSubview:self.loginButton];
        [self addSubview:self.loginByCodeButton];
        [self addSubview:self.loginByWeChatButton];
        
        
    }
    return self;
}

- (UITextField *)userNameTextField
{
    if (_userNameTextField) {
        return _userNameTextField;
    }
    _userNameTextField = [[UITextField alloc]
                          initWithFrame:CGRectMake(18, _logoImageView.bottom, SCREEN_WIDTH-36, 40)
                          Left:self.userIconImageView
                          Right:nil
                          placeholder:@"请输入手机号/用户名"];
    
    [_userNameTextField renderFont:RS_FONT_F2
                         textColor:RS_COLOR_C3
                      cornerRadius:4];
    
    return _userNameTextField;
}

- (UIImageView *)logoImageView
{
    if (_logoImageView) {
        return _logoImageView;
    }
    
    _logoImageView = [RSImageView imageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 119) ImageName:@"icon_login_logo"];
    if (iPhone5S || iPhone6) {
        _logoImageView.height = 151;
    }
    if (iPhone6Plus) {
        _logoImageView.height = 194;
    }
    
    return _logoImageView;
}

-(UIImageView *)userIconImageView
{
    if (_userIconImageView) {
        return _userIconImageView;
    }
    
    _userIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 40)];
    _userIconImageView.contentMode = UIViewContentModeCenter;
    _userIconImageView.image = [UIImage imageNamed:@"icon_user"];
    
    return _userIconImageView;
}

-(UITextField *)pwdTextField
{
    if (_pwdTextField) {
        return _pwdTextField;
    }
    
    _pwdTextField = [[UITextField alloc]
                     initWithFrame:CGRectMake(self.userNameTextField.left, self.userNameTextField.bottom + 10, self.userNameTextField.width, self.userNameTextField.height)
                     Left:self.pwdIconImageView
                     Right:self.forgetPwdButton
                     placeholder:@"请输入密码"];
    
    [_pwdTextField renderFont:RS_FONT_F2 textColor:RS_COLOR_C3 cornerRadius:4];
    _pwdTextField.secureTextEntry = YES;
    
    return _pwdTextField;
}

-(UIImageView *)pwdIconImageView
{
    if (_pwdIconImageView) {
        return _pwdIconImageView;
    }
    
    _pwdIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 40)];
    _pwdIconImageView.contentMode = UIViewContentModeCenter;
    _pwdIconImageView.image = [UIImage imageNamed:@"icon_pwd"];
    
    return _pwdIconImageView;
}

- (UIButton *)forgetPwdButton
{
    if (_forgetPwdButton) {
        return _forgetPwdButton;
    }
    _forgetPwdButton = [RSButton buttonWithFrame:CGRectMake(15, 0, 74, 24) ImageName:nil Text:@"忘记密码?" TextColor:RS_COLOR_C4];
    _forgetPwdButton.titleLabel.font = RS_FONT_F4;
    
    return _forgetPwdButton;
}

- (UIButton *)loginByCodeButton
{
    if (_loginByCodeButton) {
        return _loginByCodeButton;
    }
    _loginByCodeButton = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-120, self.loginButton.bottom+15, 100, 30) ImageName:@"icon_logindir" Text:@"验证码登录" TextColor:RS_COLOR_C1];
    _loginByCodeButton.titleLabel.font = RS_FONT_F2;
    _loginByCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    _loginByCodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -152);
    
    return _loginByCodeButton;
}

- (UIButton *)loginButton
{
    if (_loginButton) {
        return _loginButton;
    }
    
    _loginButton = [RSButton buttonWithFrame:CGRectMake(18, self.pwdTextField.bottom+20, SCREEN_WIDTH-36, 38) ImageName:nil Text:@"登录" TextColor:RS_COLOR_C7];
    _loginButton.backgroundColor = RS_Theme_Color;
    _loginButton.layer.cornerRadius = 6;
    return _loginButton;
}

-(UIButton *)loginByWeChatButton
{
    if (_loginByWeChatButton) {
        return _loginByWeChatButton;
    }
    
    _loginByWeChatButton = [RSButton buttonWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, self.loginByCodeButton.bottom + 30, 60, 60) ImageName:@"icon_weixin" Text:nil TextColor:RS_Clear_Clor];
    _loginByWeChatButton.contentMode = UIViewContentModeCenter;
    
    return _loginByWeChatButton;
    
}

- (void)layoutSubviews
{
    self.loginByWeChatButton.y = SCREEN_HEIGHT - 42.5-45-64;
    if (iPhone5S || iPhone6) {
        self.logoImageView.height = 151;
        self.loginByWeChatButton.y = SCREEN_HEIGHT - 64 - 86 - 45;
    }
    if (iPhone6Plus) {
        self.logoImageView.height = 194;
        self.loginByWeChatButton.y = SCREEN_HEIGHT - 64 - 116 - 45;
    }
    
    if (self.loginType == 1) {
        self.userNameTextField.placeholder = @"请输入用户名/手机号";
        
        self.pwdTextField.placeholder = @"请输入密码";
        self.pwdTextField.rightView = self.forgetPwdButton;
        self.pwdTextField.secureTextEntry = YES;

        [self.loginByCodeButton setTitle:@"验证码登录" forState:UIControlStateNormal];
        _loginByCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        _loginByCodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -152);
    }else{
        self.userNameTextField.placeholder = @"请输入手机号";
        [self.loginByCodeButton setTitle:@"密码登录" forState:UIControlStateNormal];
        self.loginByCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        self.loginByCodeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -140);
        
        contentView = [[UIView alloc]initWithFrame:self.sendCodeButton.frame];
        contentView.width = self.sendCodeButton.width + 15;
        [contentView addSubview:self.sendCodeButton];
        
        self.pwdTextField.placeholder = @"请输入验证码";
        self.pwdTextField.rightView = contentView;
        self.pwdTextField.secureTextEntry = NO;
        
    }
}

- (UIButton *)sendCodeButton
{
    if (_sendCodeButton) {
        return _sendCodeButton;
    }
    
    _sendCodeButton = [RSButton themeBorderButton:CGRectMake(0, 0, 74, 24) Text:@"发送验证码"];
    return _sendCodeButton;
}

@end
