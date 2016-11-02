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
    RSButton *_registerBtn;
}
@end

@implementation LoginViewController

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    
    self.loginView = [[LoginView alloc]initWithFrame:self.view.frame];
    self.loginView.loginType = 1;
    self.loginView.delegate = self;
    self.loginView.scrollEnabled = YES;
    [self.loginView addTapAction:@selector(hideKeyboard) target:self];
    [self.view addSubview:self.loginView];
    
    self.loginModel = [[LoginModel alloc]init];
    [self bandleRAC];
    [self dealAction];
    
    //注册
     _registerBtn = [RSButton buttonWithFrame:CGRectMake(0, 0, 60, 44) ImageName:nil Text:@"注册" TextColor:RS_COLOR_C7];
    _registerBtn.titleLabel.font = RS_FONT_F2;
    CGSize size = [_registerBtn.titleLabel sizeThatFits:CGSizeMake(60, 44)];
    _registerBtn.width = size.width;
    @weakify(self)
    [[_registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        NSString* urlStr = [NSString URLencode:APP_REGISTER_URL stringEncoding:NSUTF8StringEncoding];
        UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://RSJSWeb?urlString=%@&isEncodeURL=1",urlStr]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_registerBtn];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.loginView addGestureRecognizer:recognizer];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    iv.image = [UIImage imageNamed:@"nav-goback"];
    [iv addTapAction:@selector(backUp) target:self];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:iv];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)keyboardWillChangeFrame
{
    [self hideKeyboard];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    [self hideKeyboard];
}


- (void)bandleRAC
{
    @weakify(self)
    [[self.loginView.userNameTextField rac_textSignal] subscribeNext:^(NSString *value) {
        @strongify(self)
        self.loginModel.userName = value;
    }];
    
    [[self.loginView.pwdTextField rac_textSignal] subscribeNext:^(NSString *value) {
        if (self.loginView.loginType == 1) {
            self.loginModel.passWord = value;
        }
        if (self.loginView.loginType == 2) {
            self.loginModel.code = value;
        }
    }];
}

- (void)dealAction
{
    self.loginView.userNameTextField.delegate = self;
    self.loginView.pwdTextField.delegate = self;
    
    @weakify(self)
    [[self.loginView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.loginView.loginType == 1) {
            [self.loginModel loginbyPassword:^{
                [AppConfig getAPPDelegate].userValid = YES;
//                [self.navigationController popViewControllerAnimated:YES];
                [self backUp];
            }];
        }
        if (self.loginView.loginType == 2) {
            [self.loginModel loginByMobileCode:^{
                [AppConfig getAPPDelegate].userValid = YES;
                [self backUp];
            }];
        }
    }];
    
    [[self.loginView.loginByWeChatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self loginWithWeixin];
    }];
    
    [[self.loginView.forgetPwdButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self findPassWord];
    }];
    
    [[self.loginView.sendCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self sendCode];
    }];
    
    [[self.loginView.loginByCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self hideKeyboard];
        self.loginView.userNameTextField.text = @"";
        self.loginView.pwdTextField.text = @"";
        if (self.loginView.loginType == 1) {
            self.loginView.loginType = 2;
        }else{
            self.loginView.loginType = 1;
        }
        [self.loginView setNeedsLayout];
        [self.loginView layoutIfNeeded];
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


#pragma mark 键盘操作
-(void)editing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         self.loginView.contentInset = UIEdgeInsetsMake(-100, 0.0f, 0.0f, 0.0f);
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
                         self.loginView.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
    [self.loginView.userNameTextField resignFirstResponder];
    [self.loginView.pwdTextField resignFirstResponder];
}

#pragma mark textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self editing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.loginView.userNameTextField) {
        if([textField.text length] >= 11 && ![string isEqualToString:@""]) {
            [self.loginView.pwdTextField becomeFirstResponder];
        }
    }
    return YES;
}

#pragma mark back
-(void)backUp{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendCode
{
    [self.loginModel sendCode:^{
        [RSButton countDown:self.loginView.sendCodeButton];
    }];
}

- (void)findPassWord
{
    NSString* urlStr = [NSString URLencode:APP_RESETPWD_URL stringEncoding:NSUTF8StringEncoding];
    UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://RSJSWeb?urlString=%@&isEncodeURL=1",urlStr]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
