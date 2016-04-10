//
//  MTAlertViewController.h
//  iMerchant
//
//  Created by lishipeng on 14-7-9.
//  Copyright (c) 2014年 Sankuai. All rights reserved.
//


@interface RSAlertView : UIView

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) NSString *leftBtnText;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSString *rightBtnText;
@property (nonatomic, strong) UIView *bgImgView;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t beforeShowBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

-(id) initWithTile:(NSString *)title msg:(NSString *)msg leftButtonTitle:(NSString *)leftBtnText rightButtonTitle:(NSString *)rightBtnText;

-(id) initWithTile:(NSString *)title msg:(NSString *)msg leftButtonTitle:(NSString *)leftBtnText rightButtonTitle:(NSString *)rightBtnText AndLeftBlock:(dispatch_block_t)leftBlock RightBlock:(dispatch_block_t)rightBlock;

-(void)show;
@end
