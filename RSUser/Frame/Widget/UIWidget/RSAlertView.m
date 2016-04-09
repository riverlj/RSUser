//
//  RSAlertViewController.m
//  iMerchant
//
//  Created by lishipeng on 14-7-9.
//  Copyright (c) 2014年 Sankuai. All rights reserved.
//

#import "RSAlertView.h"

#define ALERTVIEW_WIDTH 270
#define ALERTVIEW_TITLE_HEIGHT 47

@interface RSAlertView ()

@end

@implementation RSAlertView

-(id)initWithTile:(NSString *)title msg:(NSString *)msg leftButtonTitle:(NSString *)leftBtnText rightButtonTitle:(NSString *)rightBtnText
{
    self = [super init];
    if(self){
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setBackgroundColor:RGBA(0x33, 0x33, 0x33,0.5)];
        self.title = title;
        self.msg = msg;
        self.leftBtnText = leftBtnText;
        self.rightBtnText = rightBtnText;
    }
    return self;
}

-(UILabel *) titleLabel
{
    if(_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ALERTVIEW_WIDTH, ALERTVIEW_TITLE_HEIGHT)];
    _titleLabel.textColor = RS_Sub_Text_Color;
    _titleLabel.backgroundColor = RS_Main_Text_Color;
    _titleLabel.font = BoldFont(17);
    _titleLabel.numberOfLines = 1;
    return _titleLabel;
}

-(UILabel *) contentLabel
{
    if(_contentLabel) {
        return _contentLabel;
    }
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 15, ALERTVIEW_WIDTH-30, 100)];
    _contentLabel.textColor = RS_Sub_Text_Color;
    _contentLabel.font = RS_Main_FontSize;
    _contentLabel.numberOfLines = 0;
    return _contentLabel;
    
}

-(UIButton *) leftButton
{
    if(_leftButton) {
        return _leftButton;
    }
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 124, 35);
    
    [_leftButton setBackgroundImage:[[UIImage imageNamed:@"normalButton.png"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f] forState:UIControlStateNormal];
    [_leftButton setBackgroundImage:[[UIImage imageNamed:@"normalButton_pressed.png"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    return _leftButton;
}

-(UIView *) alertView
{
    if(_alertView) {
        return _alertView;
    }
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ALERTVIEW_WIDTH, 300)];
    [_alertView setBackgroundColor:RS_White_Color];
    CALayer *layer=[_alertView layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:5.0];
    return _alertView;
}


-(void) layout
{
    [self.alertView removeAllSubviews];
    float height = 0;
    if(self.title) {
        self.titleLabel.text = [NSString stringWithFormat:@"    %@", self.title ];
        [self.alertView addSubview:self.titleLabel];
        height += self.titleLabel.height;
    }
    height += 15;
    if(self.msg) {
        self.contentLabel.text = self.msg;
        //动态调整content的高度
        CGSize constraint = CGSizeMake(self.contentLabel.width, 20000.0f);
        CGSize size = [self.msg sizeWithFont:self.contentLabel.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        self.contentLabel.height = MIN(200.0f, size.height);
        self.contentLabel.top = height;
        [self.alertView addSubview:self.contentLabel];
        height += self.contentLabel.height;
    }
    height += 30;
    
    if(self.leftBtnText) {
        self.leftButton.titleLabel.text = self.leftBtnText;
        [self.alertView addSubview:self.leftButton];
        self.leftButton.top = height;
        self.leftButton.left = 73;
        height += self.leftButton.height;
        height+=30;
    }
    
    self.alertView.frame = CGRectMake((self.width - ALERTVIEW_WIDTH)/2, (self.height-height)/2, ALERTVIEW_WIDTH, height);
    [self addSubview:self.alertView];
}

//将当前view从主界面中移除
-(void) dismissAlert
{
    if(self.dismissBlock) {
        self.dismissBlock();
    }
    [self removeFromSuperview];
}

//页面展示
- (void)show
{
    UIViewController *topVC = [self superViewController];
    self.alertView.frame = CGRectMake(self.width/2, self.height/2, 0, 0);
    [UIView animateWithDuration:0.35f animations:^{
        [self layout];
        [topVC.view addSubview:self];
    }];
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

- (void)removeFromSuperview
{
    [self.bgImgView removeFromSuperview];
    self.bgImgView = nil;
    [UIView animateWithDuration:0.35f animations:^{
        self.alertView.frame = CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}


@end
