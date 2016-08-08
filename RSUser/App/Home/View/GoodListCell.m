//
//  RSHomeCell.m
//  RSUser
//
//  Created by WuRibatu on 15/10/26.
//  Copyright © 2015年 WuRibatu. All rights reserved.
//

#import "GoodListCell.h"
#import "RSLabel.h"
#import "CartNumberLabel.h"
#import "ThrowLineTool.h"
#import "CartModel.h"

@implementation CartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    // 商品名称
    self.titleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_COLOR_C1];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = Font(14);
    [self.contentView addSubview:self.titleLabel];
    
    self.priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_Theme_Color FontSize:14];
    [self.contentView addSubview:self.priceLabel];
    
    CGSize addSize = [UIImage imageNamed:@"addActivate"].size;
    self.addIV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, 16.5, addSize.width, addSize.height)];
    [self.contentView addSubview:self.addIV];
    [self.addIV setImage:[UIImage imageNamed:@"addActivate"]];
    [self.addIV addTapAction:@selector(addCountClick) target:self];
    
    self.countLabel = [RSLabel lableViewWithFrame:CGRectMake(self.addIV.x- 38, self.addIV.top, 38, self.addIV.height) bgColor:[UIColor clearColor] textColor:RS_COLOR_NUMLABEL];
    self.countLabel.font = RS_FONT_F2;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.countLabel];
    
    self.subIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.countLabel.x-addSize.width, self.addIV.top, self.addIV.width, self.addIV.height)];
    [self.subIV setImage:[UIImage imageNamed:@"subActivate"]];
    [self.contentView addSubview:self.subIV];
    [self.subIV addTapAction:@selector(subCountClick) target:self];
    
    self.lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 1) Color:RS_Line_Color];
    [self.contentView addSubview:self.lineView];
    
}

-(void)setModel:(GoodListModel *)model
{
    _cartmodel = model;
    self.titleLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.saleprice];
    self.countLabel.text = [NSString stringWithFormat:@"%zd", model.num];
    [self setFramesWithModel:model];
}

- (void)setFramesWithModel:(GoodListModel *)model
{
    self.titleLabel.frame = CGRectMake(18, 0, SCREEN_WIDTH/2-20, 49);
    CGSize priceSize = [self.priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, self.titleLabel.height)];
    self.priceLabel.frame = CGRectMake(SCREEN_WIDTH/2, 0, priceSize.width, _titleLabel.height);
    
    self.lineView.y = 48;
}

- (void)addCountClick
{
    [[Cart sharedCart] addGoods:_cartmodel];
    _cartmodel.num ++;
    self.countLabel.text = [NSString stringWithFormat:@"%zd", _cartmodel.num];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
}

-(void)subCountClick
{
    [[Cart sharedCart] deleteGoods:_cartmodel];
    _cartmodel.num --;
    self.countLabel.text = [NSString stringWithFormat:@"%zd", _cartmodel.num];
 

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
}

@end

@interface GoodListCell ()<ThrowLineToolDelegate>

@property (nonatomic,assign) NSInteger count;
@end

@implementation GoodListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 71, 71)];
    _iconIV.layer.cornerRadius = 3;
    _iconIV.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconIV];
    
    _saledLabel = [RSLabel lableViewWithFrame:CGRectMake(0, _iconIV.height-15, _iconIV.width, 15) bgColor:RS_COLOR_C4 textColor:RS_COLOR_C7];
    _saledLabel.backgroundColor = RGBA(204, 204, 204, 0.4);
    _saledLabel.font = RS_FONT_F4;
    [_iconIV addSubview:_saledLabel];

    self.titleLabel = [RSLabel lableViewWithFrame:CGRectMake(_iconIV.right + 12, 15, SCREEN_WIDTH-_iconIV.right - 30, 0) bgColor:[UIColor clearColor] textColor:RS_COLOR_C1];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.self.titleLabel.font = RS_FONT_F2;
    [self.contentView addSubview:self.self.titleLabel];
    
    _menuLabel = [RSLabel lableViewWithFrame:CGRectMake(self.titleLabel.x, 0, self.titleLabel.width, 0) bgColor:[UIColor clearColor] textColor:RS_COLOR_C4];
    _menuLabel.textAlignment = NSTextAlignmentLeft;
    _menuLabel.font = RS_FONT_F4;
    [self.contentView addSubview:_menuLabel];
    
    self.priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_Theme_Color];
    self.priceLabel.font = RS_FONT_F4;
    [self.contentView addSubview:self.priceLabel];
    
    CGSize addSize = [UIImage imageNamed:@"addActivate"].size;
    self.addIV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-26, 93/2, 2*addSize.width, 93/2)];
    self.addIV.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:self.addIV];
    self.addIV.hidden = YES;
    [self.addIV setImage:[UIImage imageNamed:@"addActivate"]];
    [self.addIV addTapAction:@selector(addCountClick) target:self];
    
    self.countLabel = [RSLabel lableViewWithFrame:CGRectMake(self.addIV.x- 38, self.addIV.top, 38, self.addIV.height) bgColor:[UIColor clearColor] textColor:RS_COLOR_NUMLABEL];
    self.countLabel.font = RS_FONT_F2;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.hidden = YES;
    [self.countLabel addTapAction:@selector(countLabelClicked) target:self];
    [self.contentView addSubview:self.countLabel];
    
    self.subIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.countLabel.x-3*addSize.width, self.addIV.top, 3*addSize.width, self.addIV.height)];
    self.subIV.contentMode = UIViewContentModeRight;
    [self.subIV setImage:[UIImage imageNamed:@"subActivate"]];
    [self.contentView addSubview:self.subIV];
    self.subIV.hidden = YES;
    [self.subIV addTapAction:@selector(subCountClick) target:self];
        
    self.selloutLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-54, 93/2+10, 54, 20)];
    self.selloutLabel.text = @"已售罄";
    self.selloutLabel.textColor = RS_COLOR_C7;
    self.selloutLabel.backgroundColor = RS_COLOR_C4;
    self.selloutLabel.font = RS_FONT_F4;
    self.selloutLabel.hidden = YES;
    self.selloutLabel.layer.cornerRadius = 5;
    self.selloutLabel.layer.masksToBounds = YES;
    self.selloutLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.selloutLabel];
    
    self.lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(10, 92, SCREEN_WIDTH-10, 1) Color:RS_Line_Color];
    self.lineView.hidden = YES;
    [self.contentView addSubview:self.lineView];
}

- (void)setModel:(GoodListModel *)model
{
    _listModel = model;
    
    // 重用机制导致显示不一致
    self.selloutLabel.hidden = YES;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    self.titleLabel.text = model.name;
    _menuLabel.text = model.desc;
    _saledLabel.text = [NSString stringWithFormat:@"已售%zd份", model.saled];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.saleprice];
    self.countLabel.text = [NSString stringWithFormat:@"%zd", model.num];

    if (_listModel.num == 0) {
        self.addIV.hidden = NO;
        self.countLabel.hidden = YES;
        self.subIV.hidden =YES;
    } else {
        self.addIV.hidden = NO;
        self.countLabel.hidden = NO;
        self.subIV.hidden =NO;
    }
    
    if (_listModel.canbuymax == 0) {
        self.addIV.hidden = YES;
        self.subIV.hidden = YES;
        self.selloutLabel.hidden = NO;
    }
    
    self.lineView.hidden = model.hiddenLine;

    
    [self setFramesWithModel:model];
}

- (void)setFramesWithModel:(GoodListModel *)model
{
    CGSize nameSize = [self.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    self.titleLabel.height = nameSize.height;
    
    _menuLabel.y = self.titleLabel.bottom + 8;
    CGSize menuSize = [_menuLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    _menuLabel.height = menuSize.height;
    
    self.priceLabel.x = self.titleLabel.x;
    self.priceLabel.y = _menuLabel.bottom + 10;
    CGSize priceSize = [self.priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    self.priceLabel.size = priceSize;

}

- (void)countLabelClicked{}

- (void)addCountClick
{
    if (self.countLabel.text.integerValue >= self.listModel.canbuymax && self.listModel.canbuymax!=-1) {
        
        [[RSToastView shareRSToastView] showToast:@"库存不足啦，先买这么多吧～"];
        return;
    }
    CGSize addSize = [UIImage imageNamed:@"addActivate"].size;
    UIImageView *throwedView = [[UIImageView alloc]init];
    throwedView.frame = CGRectMake(self.addIV.x, self.addIV.y + (self.addIV.y - addSize.height)/2, addSize.width, addSize.height);
    [throwedView setImage:[UIImage imageNamed:@"addActivate"]];
    throwedView.contentMode = UIViewContentModeLeft;

    throwedView.tag = 10;
    [self.contentView addSubview:throwedView];
    
    
    ThrowLineTool *throwLineTool = [ThrowLineTool sharedTool];
    throwLineTool.delegate = self;
    CartNumberLabel *cartNumberLabel = [CartNumberLabel shareCartNumberLabel];
    CGPoint cartLabelPoint = cartNumberLabel.center;
    
    cartLabelPoint = [cartNumberLabel.superview convertPoint:cartLabelPoint toView:self.contentView];
    CGRect beginRect = [self.addIV.superview convertRect:self.addIV.frame toView:nil];
    CGRect endRect = [cartNumberLabel.superview convertRect:cartNumberLabel.frame toView:nil];
    cartLabelPoint = [cartNumberLabel.superview convertPoint:cartLabelPoint toView:nil];
    
    CGPoint benginPoint = CGPointMake(beginRect.origin.x+self.addIV.width/2, beginRect.origin.y+self.addIV.height/2);
    CGPoint endpoint = CGPointMake(endRect.origin.x+cartNumberLabel.width/2, endRect.origin.y+cartNumberLabel.height/2);
    
    UIWindow *window = [AppConfig getAPPDelegate].window;
    throwedView.frame = beginRect;
    [window addSubview:throwedView];
    
    [throwLineTool throwObject:throwedView from:benginPoint to:endpoint height:40 duration:0.5];
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] +1];

    
    if ([self.countLabel.text integerValue] > 0)
    {
        self.subIV.hidden = NO;
        self.countLabel.hidden = NO;
    }
    
    [[Cart sharedCart] addGoods:_listModel];
    
}

- (void)animationDidFinish
{
    [[[AppConfig getAPPDelegate].window viewWithTag:10] removeFromSuperview];
}

- (void)subCountClick
{
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] -1];
    if ([self.countLabel.text integerValue] == 0)
    {
        self.subIV.hidden = YES;
        self.countLabel.hidden = YES;
    }
    
    [[Cart sharedCart] deleteGoods:_listModel];
}

@end
