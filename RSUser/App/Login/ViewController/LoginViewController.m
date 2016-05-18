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
#import "RSJSWebViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UIScrollView *scrolView;
    RSTextFiled *userTextFiled;
    RSTextFiled *pwdTextFiled;
    RSButton *loginBtn;
    RSButton *codeloginBtn;
    RSButton *forgetPwdBtn;
    UIImageView *weixinImageView;
    UIView *pwdRightView;
    
    LoginModel *_loginModel;
   
}
@end

@implementation LoginViewController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    self.type = 1;
    [self initView];
    
}

- (void)initView
{
    [self.view removeAllSubviews];
    _loginModel = [[LoginModel alloc] init];
    
    scrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [scrolView addTapAction:@selector(hideKeyboard) target:self];
    [self.view addSubview:scrolView];
    
    RSButton *registerBtn = [RSButton buttonWithFrame:CGRectMake(0, 0, 60, 44) ImageName:nil Text:@"注册" TextColor:RS_TabBar_count_Color];
    registerBtn.titleLabel.font = RS_FONT_F2;
    CGSize size = [registerBtn.titleLabel sizeThatFits:CGSizeMake(60, 44)];
    registerBtn.width = size.width;
    
    @weakify(self)
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        NSString* urlStr = [NSString URLencode:APP_REGISTER_URL stringEncoding:NSUTF8StringEncoding];
        UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://RSJSWeb?urlString=%@&isEncodeURL=1",urlStr]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:registerBtn];
  
    UIImageView *logoImageView = [RSImageView imageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 119) ImageName:@"icon_login_logo"];
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
    userTextFiled.textColor = RS_COLOR_C3;
    userTextFiled.font = RS_FONT_F2;
    userTextFiled.delegate = self;
    [scrolView addSubview:userTextFiled];
    
    pwdTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(18, userTextFiled.bottom+7, SCREEN_WIDTH-36, 40)  cornerRadius:4 LeftImageName:@"icon_pwd"];
    pwdTextFiled.delegate = self;
    pwdTextFiled.textColor = RS_COLOR_C3;
    pwdTextFiled.font = RS_FONT_F2;
    pwdTextFiled.placeholder = @"请输入密码";
    pwdTextFiled.secureTextEntry = YES;
    [scrolView addSubview:pwdTextFiled];
    
    pwdRightView = [[UIView alloc]init];
    forgetPwdBtn = [RSButton buttonWithFrame:CGRectMake(15, 0, 74, 24) ImageName:nil Text:@"忘记密码?" TextColor:RS_Sub_Text_Color];
    pwdRightView.frame = forgetPwdBtn.frame;
    pwdRightView.width = forgetPwdBtn.width + 15;
    
    if (self.type == 1) {
        [[forgetPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self findPassWord];
        }];
    }
    
    if (self.type == 2) {
        [forgetPwdBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [forgetPwdBtn setTitleColor:RS_Theme_Color forState:UIControlStateNormal];
        forgetPwdBtn.layer.borderColor = RS_Theme_Color.CGColor;
        forgetPwdBtn.layer.borderWidth = 1;
        forgetPwdBtn.layer.cornerRadius = 6;
        pwdRightView.width = forgetPwdBtn.width + 30;
        //发送验证码
        @weakify(self)
        [[forgetPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self sendCode];
        }];
    }
    pwdRightView.backgroundColor = [UIColor clearColor];
    [pwdRightView addSubview:forgetPwdBtn];
    forgetPwdBtn.titleLabel.font = RS_SubButton_Font;
    pwdTextFiled.rightView = pwdRightView;
    pwdTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    
    loginBtn =[RSButton buttonWithFrame:CGRectMake(18, pwdTextFiled.bottom+20, SCREEN_WIDTH-36, 38) ImageName:nil Text:@"登录" TextColor:RS_TabBar_count_Color];
    loginBtn.backgroundColor = RS_Theme_Color;
    loginBtn.layer.cornerRadius = 6;
    [scrolView addSubview:loginBtn];
    
    codeloginBtn = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-120, loginBtn.bottom+15, 100, 30) ImageName:@"icon_logindir" Text:@"验证码登录" TextColor:RS_MainLable_Text_Color];
    codeloginBtn.titleLabel.font = RS_MainLable_Font;
    codeloginBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    codeloginBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -152);
    [scrolView addSubview:codeloginBtn];
    
    if (self.type == 2)
    {
        pwdTextFiled.placeholder = @"请输入验证码";
        pwdTextFiled.secureTextEntry = NO;
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
    
    
    [self addObserver];
    [self login];

}

- (void)addObserver
{
    [[userTextFiled rac_textSignal] subscribeNext:^(NSString *userName) {
        _loginModel.userName = userName;
    }];
    
    [[pwdTextFiled rac_textSignal] subscribeNext:^(NSString *password) {
        if (self.type == 1) {
            _loginModel.passWord = password;
        }
        if (self.type == 2) {
            _loginModel.code = password;
        }
    }];
}

#pragma mark 微信登陆
- (void)loginWithWeixin
{
    if ([WXApi isWXAppInstalled]) {
        [LoginModel sendAuthRequest];
    }else{
        [[RSToastView shareRSToastView] showToast:@"请先安装微信客户端"];
    }
}

- (void)login
{
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //TODO 登录条件判断
        if (_type == 1) {
            //用户名密码登陆
            [_loginModel loginbyPassword:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
        if (_type == 2) {
            //验证码登陆
            [_loginModel loginByMobileCode:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        
        
    }];
}

#pragma mark 键盘操作
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
    [pwdTextFiled resignFirstResponder];
}

#pragma mark textField delegate
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

#pragma mark back
-(void)backUp{
    [AppConfig getAPPDelegate].tabBarControllerConfig.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  发送验证码
 */
- (void)sendCode
{
    [_loginModel sendCode:^{
        [RSButton countDown:forgetPwdBtn];
    }];
    
    
}

/**
 *  找回密码
 */
- (void)findPassWord
{
    NSString* urlStr = [NSString URLencode:APP_RESETPWD_URL stringEncoding:NSUTF8StringEncoding];
    UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://RSJSWeb?urlString=%@&isEncodeURL=1",urlStr]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
