//
//  BandleCellPhoneViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BandleCellPhoneViewController.h"
#import "LoginModel.h"

@interface BandleCellPhoneViewController ()
{
    RSTextFiled *cellphoneTextFiled;
    RSTextFiled *codeTextFiled;
    RSButton *bandelButton;
    UIView *codeRightView;
    RSButton *sendcodedBtn;
    LoginModel *_loginModel;
}
@end

@implementation BandleCellPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.hasBackBtn = YES;
    _loginModel = [[LoginModel alloc]init];
    
    cellphoneTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(18, 15, SCREEN_WIDTH-36, 45) cornerRadius:5 Placeholder:@"请输入要绑定的手机号"];
    [[cellphoneTextFiled rac_textSignal] subscribeNext:^(NSString *userName) {
        _loginModel.userName = userName;
    }];
    [self.view addSubview:cellphoneTextFiled];
    
    codeTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(cellphoneTextFiled.x, cellphoneTextFiled.bottom+10, cellphoneTextFiled.width, cellphoneTextFiled.height) cornerRadius:5 Placeholder:@"请输入验证码"];
    [[codeTextFiled rac_textSignal] subscribeNext:^(NSString *code) {
        _loginModel.code = code;
    }];
    [self.view addSubview:codeTextFiled];
    
    sendcodedBtn = [RSButton themeBorderButton:CGRectMake(15, 0, 74, 29) Text:@"发送验证码"];
    codeRightView = [[UIView alloc]initWithFrame:sendcodedBtn.frame];
    codeRightView.width = sendcodedBtn.width + 30;
    codeRightView.backgroundColor = [UIColor clearColor];
    @weakify(self)
    [[sendcodedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self sendCode];
    }];
    [codeRightView addSubview:sendcodedBtn];
    
    codeTextFiled.rightView = codeRightView;
    codeTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    bandelButton =[RSButton buttonWithFrame:CGRectMake(18, codeTextFiled.bottom+15, SCREEN_WIDTH-36, 42) ImageName:nil Text:@"绑定" TextColor:RS_COLOR_C7];
    bandelButton.backgroundColor = RS_Theme_Color;
    bandelButton.layer.cornerRadius = 6;
    [[bandelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //TODO 绑定操作
        @strongify(self)
        [self bandleCellPhone];
    }];
    
    [self.view addSubview:bandelButton];
}

- (void)bandleCellPhone
{
    __weak BandleCellPhoneViewController *selfWeak = self;
    [_loginModel bindMobile:^{
        [selfWeak backUp];
    }];
}

- (void)sendCode
{
    [_loginModel sendCode:^{
        [RSButton countDown:sendcodedBtn];
    }];
    
}

#pragma mark back
-(void)backUp{
    [AppConfig getAPPDelegate].tabBarControllerConfig.tabBarController.selectedIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
