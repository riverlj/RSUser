//
//  LoginViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/19.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "LoginViewController.h"
#import "BandleCellPhoneViewController.h"
#import "LoginModel.h"

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
    self.title = @"登录";
    
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initView
{
    [self.view removeAllSubviews];
    
    scrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [scrolView addTapAction:@selector(hideKeyboard) target:self];
    [self.view addSubview:scrolView];
    
    RSButton *registerBtn = [RSButton buttonWithFrame:CGRectMake(0, 0, 60, 44) ImageName:nil Text:@"注册" TextColor:RS_TabBar_count_Color];
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:registerBtn];
    
    RSImageView *logoImageView = [RSImageView imageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 119) ImageName:@"icon_login_logo"];
    [scrolView addSubview:logoImageView];
    weixinImageView = [RSImageView imageViewWithFrame:CGRectMake((SCREEN_WIDTH-45)/2, codeloginBtn.bottom+30, 45, 45) ImageName:@"icon_weixin"];
    weixinImageView.y = SCREEN_HEIGHT - 42.5-45-64;
    [weixinImageView addTapAction:@selector(loginWithWeixin) target:self];
    [scrolView addSubview:weixinImageView];
    if (iPhone5S || iPhone6) {
        logoImageView.height = 151;
        weixinImageView.y = SCREEN_HEIGHT - 64 - 86 - 45;
    }
    if (iPhone6Plus) {
        logoImageView.height = 194;
        weixinImageView.y = SCREEN_HEIGHT - 64 - 116 - 45;
    }
    
    userTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(18, logoImageView.bottom, SCREEN_WIDTH-36, 40) cornerRadius:4 LeftImageName:@"icon_user"];
    userTextFiled.placeholder = @"请输入手机号";
    userTextFiled.delegate = self;
    
    pwdTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(18, userTextFiled.bottom+7, SCREEN_WIDTH-36, 40)  cornerRadius:4 LeftImageName:@"icon_pwd"];
    pwdTextFiled.delegate = self;
    pwdTextFiled.placeholder = @"请输入密码";
    pwdTextFiled.secureTextEntry = YES;
    [scrolView addSubview:userTextFiled];
    [scrolView addSubview:pwdTextFiled];
    
    pwdRightView = [[UIView alloc]init];
    RSButton *forgetPwdBtn = [RSButton buttonWithFrame:CGRectMake(15, 0, 74, 24) ImageName:nil Text:@"忘记密码?" TextColor:RS_Sub_Text_Color];
    pwdRightView.frame = forgetPwdBtn.frame;
    pwdRightView.width = forgetPwdBtn.width + 15;
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
    
    
    loginBtn =[RSButton buttonWithFrame:CGRectMake(18, pwdTextFiled.bottom+20, SCREEN_WIDTH-36, 38) ImageName:nil Text:@"登录" TextColor:RS_TabBar_count_Color];
    loginBtn.backgroundColor = RS_Theme_Color;
    loginBtn.layer.cornerRadius = 6;
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //TODO 登录条件判断
        BandleCellPhoneViewController *bv = [[BandleCellPhoneViewController alloc]init];
        [self.navigationController pushViewController:bv animated:YES];
        
    }];
    [scrolView addSubview:loginBtn];
    
    codeloginBtn = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-120, loginBtn.bottom+15, 100, 30) ImageName:@"icon_logindir" Text:@"验证码登录" TextColor:RS_MainLable_Text_Color];
    codeloginBtn.titleLabel.font = RS_MainLable_Font;
    codeloginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    codeloginBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -152);
    [scrolView addSubview:codeloginBtn];
    
    if (self.type == 2)
    {
        [codeloginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        codeloginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        codeloginBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -140);
        [[codeloginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            _type = 1;
            [self initView];
        }];
    }
    else
    {
        [[codeloginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            _type = 2;
            [self initView];
        }];
    }

}

- (void)loginWithWeixin
{
    if ([WXApi isWXAppInstalled]) {
        [LoginModel sendAuthRequest];
    }else{
        RSAlertView *alertView = [[RSAlertView alloc]initWithTile:@"温馨提示" msg:@"请先安装微信客户端" leftButtonTitle:@"我知道了" AndLeftBlock:nil];
        [alertView show];
    }
}

/**
 *  微信登陆授权成功
 */
- (void)loginWithWeixinSuceess
{
    //TODO 判断是非已经绑定了手机号
    if (YES)
    {
        //TODO 调转到首页
    }
    else
    {
        //TODO 未绑定，跳转到绑定手机页, 绑定成功，跳转到APP首页
    }
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