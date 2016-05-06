//
//  CodesView.m
//  RSUser
//
//  Created by 李江 on 16/5/5.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "CodesView.h"


@interface CodesView()<UITextFieldDelegate>
{
    UILabel *titleLabel;
    UILabel *changeCodeLabel;
    UIImageView *codeImageView;
    UITextField *codeTextField;
    UIView *lineView;
    UIButton *okButton;
    UIView *contentView;
    dispatch_block_t _okBlock;
}
@end


@implementation CodesView

-(id) initWithOkBlock:(dispatch_block_t)okBlock
{
    self = [self init];
    if (self) {
        _okBlock = okBlock;
    }
    return self;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = RS_COLOR_C7;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setBackgroundColor:RGBA(0x33, 0x33, 0x33,0.5)];
        [self addTapAction:@selector(removeView) target:self];
        
        contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 295, 167)];
        [contentView addTapAction:@selector(contentViewClicked) target:self];
        contentView.backgroundColor = RS_COLOR_C7;
        contentView.layer.cornerRadius = 10;
        [self addSubview:contentView];
        
        titleLabel = [RSLabel labelOneLevelWithFrame:CGRectMake(0, 0, contentView.width, 69) Text:@"请输入图片验证码"];
        titleLabel.font = RS_FONT_F2;
        titleLabel.textColor = RS_COLOR_C2;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        changeCodeLabel = [RSLabel labelTwoLevelWithFrame:CGRectMake(30, titleLabel.bottom, 0, 0) Text:@"看不清\n换一张"];
        changeCodeLabel.numberOfLines = 0;
        changeCodeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        changeCodeLabel.font = RS_FONT_F3;
        changeCodeLabel.textColor = RS_COLOR_C3;
        CGSize changeSize = [changeCodeLabel sizeThatFits:CGSizeMake(1000, 1000)];
        changeCodeLabel.width = changeSize.width;
        changeCodeLabel.height = changeSize.height;
        [changeCodeLabel addTapAction:@selector(changeCodeImage) target:self];
        [contentView addSubview:changeCodeLabel];
        
        codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(changeCodeLabel.right, changeCodeLabel.y, 84, 35)];
        codeImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [contentView addSubview:codeImageView];
        
        codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(codeImageView.right, changeCodeLabel.y, contentView.width-30-codeImageView.right, changeCodeLabel.height)];
        codeTextField.delegate = self;
        codeTextField.placeholder = @"验证码";
        codeTextField.textColor = RS_COLOR_C2;
        codeTextField.font = RS_FONT_F4;
        
        [contentView addSubview:codeTextField];
        
        lineView = [RSLineView lineViewHorizontal];
        lineView.x = changeCodeLabel.x;
        lineView.width = codeTextField.right-changeCodeLabel.x;
        lineView.y = codeImageView.bottom + 5;
        [contentView addSubview:lineView];
        
        UIView *lineView1 = [RSLineView lineViewHorizontal];
        lineView1.y = lineView.bottom + 15;
        lineView1.width = contentView.width;
        lineView1.x = 0;
        [contentView addSubview:lineView1];
        
        okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        okButton.frame = CGRectMake(0, lineView1.bottom, contentView.width, contentView.height-lineView1.bottom);
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:RS_Theme_Color forState:UIControlStateNormal];
        okButton.titleLabel.font = RS_FONT_F2;
        [okButton addTarget:self action:@selector(saveCode) forControlEvents:UIControlEventTouchUpInside];
        
        [contentView addSubview:okButton];

        [self changeCodeImage];
    }
    
    return self;
}

- (void) removeView
{
    [self removeFromSuperview];
    [self endEditing:YES];
}

- (void)saveCode
{
    [NSUserDefaults setValue:codeTextField.text forKey:@"code"];
    _okBlock();
    [self removeFromSuperview];
}

- (void)changeCodeImage
{
    //TODO 待优化
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"http://weixin.honglingjinclub.com/site/captcha?utm_content=%@",[UIDevice utm_content]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [codeImageView setImage:image];
        });
    });
   
    
}

//页面展示
- (void)show
{
    UIViewController *topVC = [self superViewController];
    contentView.center = topVC.view.center;
    [topVC.view addSubview:self];
    }

//获取superview
-(UIViewController *) superViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark 键盘操作
-(void)editing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         self.contentInset = UIEdgeInsetsMake(-(textField.bottom -50), 0.0f, 0.0f, 0.0f);
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
                         self.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
    [codeTextField resignFirstResponder];
}

#pragma mark textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self editing:textField];
}

- (void)contentViewClicked{}

@end
