//
//  BandleCellPhoneViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "BandleCellPhoneViewController.h"

@interface BandleCellPhoneViewController ()
{
    RSTextFiled *cellphoneTextFiled;
    RSTextFiled *codeTextFiled;
    RSButton *bandelButton;
    UIView *codeRightView;
}
@end

@implementation BandleCellPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    
    cellphoneTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(18, 15, SCREEN_WIDTH-36, 45) cornerRadius:5 Placeholder:@"请输入要绑定的手机号"];
    [self.view addSubview:cellphoneTextFiled];
    
    codeTextFiled = [RSTextFiled textFiledWithFrame:CGRectMake(cellphoneTextFiled.x, cellphoneTextFiled.bottom+10, cellphoneTextFiled.width, cellphoneTextFiled.height) cornerRadius:5 Placeholder:@"请输入验证码"];
    [self.view addSubview:codeTextFiled];
    
    RSButton *sendcodedBtn = [RSButton themeBorderButton:CGRectMake(15, 0, 74, 29) Text:@"发送验证码"];
    
    codeRightView = [[UIView alloc]initWithFrame:sendcodedBtn.frame];
    codeRightView.width = sendcodedBtn.width + 30;
    codeRightView.backgroundColor = [UIColor clearColor];
    [codeRightView addSubview:sendcodedBtn];
    
    codeTextFiled.rightView = codeRightView;
    codeTextFiled.rightViewMode = UITextFieldViewModeAlways;
    
    bandelButton =[RSButton buttonWithFrame:CGRectMake(18, codeTextFiled.bottom+15, SCREEN_WIDTH-36, 42) ImageName:nil Text:@"绑定" TextColor:RS_TabBar_count_Color];
    bandelButton.backgroundColor = RS_Theme_Color;
    bandelButton.layer.cornerRadius = 6;
    [[bandelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //TODO 绑定操作
        
    }];
    
    [self.view addSubview:bandelButton];
}

- (void)bandleCellPhone
{

}

@end
