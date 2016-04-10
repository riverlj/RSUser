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

-(id) initWithTile:(NSString *)title msg:(NSString *)msg leftButtonTitle:(NSString *)leftBtnText rightButtonTitle:(NSString *)rightBtnText AndLeftBlock:(dispatch_block_t)leftBlock RightBlock:(dispatch_block_t)rightBlock {
    self = [self initWithTile:title msg:msg leftButtonTitle:leftBtnText rightButtonTitle:rightBtnText];
    if (self) {
        self.leftBlock = leftBlock;
        self.rightBlock = rightBlock;
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
    _leftButton.frame = CGRectMake(0, 0, (ALERTVIEW_WIDTH-1)/2.0, 44);
//    [_leftButton setBackgroundImage:[[UIImage imageNamed:@"normalButton.png"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f] forState:UIControlStateNormal];
//    [_leftButton setBackgroundImage:[[UIImage imageNamed:@"normalButton_pressed.png"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (_rightButton) {
        return _rightButton;
    }
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(_leftButton.x+_leftButton.width+1, _leftButton.y, _leftButton.width, _leftButton.height);
    _rightButton.backgroundColor = _leftButton.backgroundColor;
    
    [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return _rightButton;
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
        [self.leftButton setTitle:self.leftBtnText forState:UIControlStateNormal];
        [self.leftButton setTitleColor:RS_TabBar_count_Color forState:UIControlStateNormal];
        self.leftButton.backgroundColor = [UIColor redColor];
        [self.alertView addSubview:self.leftButton];
        self.leftButton.top = height;
        self.leftButton.left = 0;
        height += self.leftButton.height;
    }
    
    if (self.rightBtnText) {
        [self.rightButton setTitle:self.rightBtnText forState:UIControlStateNormal];
        [self.rightButton setTitleColor:RS_TabBar_count_Color forState:UIControlStateNormal];
        self.rightButton.backgroundColor = [UIColor redColor];
        _rightButton.frame = CGRectMake(_leftButton.x+_leftButton.width+1, _leftButton.y, _leftButton.width, _leftButton.height);
        [self.alertView addSubview:self.rightButton];
    }
    
    self.alertView.frame = CGRectMake((self.width - ALERTVIEW_WIDTH)/2, (self.height-height)/2, ALERTVIEW_WIDTH, height);
    [self addSubview:self.alertView];
}


-(void) leftButtonClick
{
    if(self.leftBlock) {
        self.leftBlock();
    }
    [self removeFromSuperview];
}

- (void)rightButtonClick
{
    if (self.rightBlock) {
        self.rightBlock();
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

/**
 *  点击按钮后消失
 */
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
