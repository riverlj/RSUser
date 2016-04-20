//
//  LoginViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIScrollView *scrolView;
    RSTextFiled *userTextFiled;
    RSTextFiled *pwdTextFiled;
    RSButton *loginBtn;
    RSButton *codeloginBtn;
    RSImageView *weixinImageView;
    UIView *pwdRightView;
}
@end

@implementation LoginViewController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.type = 2;
    self.title = @"登录";
    scrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [scrolView addTapAction:@selector(hideKeyboard) target:self];
    scrolView.scrollEnabled = YES;
    scrolView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+64);
    [self.view addSubview:scrolView];
    
    RSButton *registerBtn = [RSButton buttonWithFrame:CGRectMake(0, 0, 60, 44) ImageName:nil Text:@"注册" TextColor:RS_TabBar_count_Color];
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:registerBtn];
    
    RSImageView *logoImageView = [RSImageView imageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 178) ImageName:@"icon_logo_login"];
    [scrolView addSubview:logoImageView];
    
    userTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(18, logoImageView.bottom, SCREEN_WIDTH-36, 45) cornerRadius:4 LeftImageName:@"icon_user"];
    [userTextFiled becomeFirstResponder];
    userTextFiled.placeholder = @"请输入手机号";
    userTextFiled.delegate = self;

    pwdTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(18, userTextFiled.bottom+10, SCREEN_WIDTH-36, 45)  cornerRadius:4 LeftImageName:@"icon_pwd"];
    pwdTextFiled.delegate = self;
    pwdTextFiled.placeholder = @"请输入密码";
    pwdTextFiled.secureTextEntry = YES;
    [scrolView addSubview:userTextFiled];
    [scrolView addSubview:pwdTextFiled];
    
    pwdRightView = [[UIView alloc]init];
    RSButton *forgetPwdBtn = [RSButton buttonWithFrame:CGRectMake(15, 0, 80, 30) ImageName:nil Text:@"忘记密码?" TextColor:RS_Sub_Text_Color];
    pwdRightView.frame = forgetPwdBtn.frame;
    if (self.type == 2) {
        [forgetPwdBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [forgetPwdBtn setTitleColor:RS_Theme_Color forState:UIControlStateNormal];
        forgetPwdBtn.layer.borderColor = RS_Theme_Color.CGColor;
        forgetPwdBtn.layer.borderWidth = 1;
        forgetPwdBtn.layer.cornerRadius = 6;
        pwdRightView.width = forgetPwdBtn.width + 30;
    }
    pwdRightView.backgroundColor = [UIColor clearColor];
    [pwdRightView addSubview:forgetPwdBtn];
    forgetPwdBtn.titleLabel.font = RS_SubButton_Font;
    pwdTextFiled.rightView = pwdRightView;
    pwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    
    loginBtn =[RSButton buttonWithFrame:CGRectMake(18, pwdTextFiled.bottom+50, SCREEN_WIDTH-36, 42) ImageName:nil Text:@"登录" TextColor:RS_TabBar_count_Color];
    loginBtn.backgroundColor = RS_Theme_Color;
    loginBtn.layer.cornerRadius = 6;
    [scrolView addSubview:loginBtn];
    
    codeloginBtn = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-120, loginBtn.bottom+23, 100, 30) ImageName:@"icon_logindir" Text:@"验证码登录" TextColor:RS_MainLable_Text_Color];
    codeloginBtn.titleLabel.font = RS_MainLable_Font;
    codeloginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    codeloginBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -152);
    [scrolView addSubview:codeloginBtn];
    if (self.type == 2) {
        [codeloginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    }
    
    weixinImageView = [RSImageView imageViewWithFrame:CGRectMake((SCREEN_WIDTH-45)/2, codeloginBtn.bottom+30, 45, 45) ImageName:@"icon_weixin"];
    [scrolView addSubview:weixinImageView];
    
}

-(void)editing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         scrolView.contentInset = UIEdgeInsetsMake(-(textField.bottom -50), 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
}


- (void)hideKeyboard
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         scrolView.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
    [userTextFiled resignFirstResponder];
    [pwdTextFiled resignFirstResponder];}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self editing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == userTextFiled) {
        if([textField.text length] >= 11 && ![string isEqualToString:@""]) {
            [pwdTextFiled becomeFirstResponder];
        }
    }
    
    return YES;
}

@end
