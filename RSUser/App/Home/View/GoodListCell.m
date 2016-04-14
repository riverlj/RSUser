//
//  RSHomeCell.m
//  RSUser
//
//  Created by WuRibatu on 15/10/26.
//  Copyright © 2015年 WuRibatu. All rights reserved.
//

#import "GoodListCell.h"
#import "GoodListModel.h"
#import "RSLabel.h"
#import "CartNumberLabel.h"
#import "ThrowLineTool.h"

@interface GoodListCell ()<ThrowLineToolDelegate>
{
    UIImageView *_throwedView;
}
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
    _iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(18, 12, 71, 71)];
    _iconIV.layer.borderWidth = 1.0f;
    _iconIV.layer.borderColor = RS_Line_Color.CGColor;
    [self.contentView addSubview:_iconIV];
    
    _saledLabel = [RSLabel lableViewWithFrame:CGRectMake(0, _iconIV.height-15, _iconIV.width, 15) bgColor:RS_Sub_Text_Color textColor:RS_TabBar_count_Color];
    _saledLabel.font = RS_SubLable_Font;
    [_iconIV addSubview:_saledLabel];

    _titleLabel = [RSLabel lableViewWithFrame:CGRectMake(_iconIV.right + 12, 15, SCREEN_WIDTH-_iconIV.right - 30, 0) bgColor:[UIColor clearColor] textColor:RS_MainLable_Text_Color];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = RS_MainLable_Font;
    [self.contentView addSubview:_titleLabel];
    
    _menuLabel = [RSLabel lableViewWithFrame:CGRectMake(_titleLabel.x, 0, _titleLabel.width, 0) bgColor:[UIColor clearColor] textColor:RS_Sub_Text_Color];
    _menuLabel.textAlignment = NSTextAlignmentLeft;
    _menuLabel.font = RS_SubLable_Font;
    [self.contentView addSubview:_menuLabel];
    
    _priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_Theme_Color];
    _priceLabel.font = RS_PriceLable_Font;
    [self.contentView addSubview:_priceLabel];
    
    _costPriceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_SubMain_Text_Color];
    _costPriceLabel.font = RS_CostPriceLable_Font;
    [self.contentView addSubview:_costPriceLabel];
    
    _deleteLineView = [[UIView alloc]init];
    [_costPriceLabel addSubview:_deleteLineView];
    _deleteLineView.backgroundColor = RS_SubMain_Text_Color;
    
    CGSize addSize = [UIImage imageNamed:@"add"].size;
    _addIV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, 62, addSize.width, addSize.height)];
    [self.contentView addSubview:_addIV];
    [_addIV setImage:[UIImage imageNamed:@"addActivate"]];
    [_addIV addTapAction:@selector(addCountClick) target:self];
    
    _countLabel = [RSLabel lableViewWithFrame:CGRectMake(_addIV.x- 38, _addIV.top, 38, _addIV.height) bgColor:[UIColor clearColor] textColor:RS_NumbLabel_Text_Color];
    _countLabel.font = RS_MainLable_Font;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_countLabel];
    
    _subIV = [[UIImageView alloc]initWithFrame:CGRectMake(_countLabel.x-addSize.width, _addIV.top, _addIV.width, _addIV.height)];
    [_subIV setImage:[UIImage imageNamed:@"subActivate"]];
    [self.contentView addSubview:_subIV];
    [_subIV addTapAction:@selector(subCountClick) target:self];
    
}

- (void)setModel:(GoodListModel *)model
{
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    _titleLabel.text     = model.name;
    _menuLabel.text      = model.desc;
    _saledLabel.text     = [NSString stringWithFormat:@"已售%ld份", model.saled];
    _priceLabel.text     = [NSString stringWithFormat:@"￥%@", model.saleprice];
    _costPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    
    [self setFramesWithModel:model];
}

- (void)setFramesWithModel:(GoodListModel *)model
{
    CGSize nameSize = [_titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    _titleLabel.height = nameSize.height;
    
    _menuLabel.y = _titleLabel.bottom + 8;
    CGSize menuSize = [_menuLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    _menuLabel.height = menuSize.height;
    
    _priceLabel.x = _titleLabel.x;
    _priceLabel.y = _menuLabel.bottom + 10;
    CGSize priceSize = [_priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    _priceLabel.size = priceSize;
    
    _costPriceLabel.x = _priceLabel.right + 5;
    CGSize costtSize = [_costPriceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    _costPriceLabel.size = costtSize;
    _costPriceLabel.y = _priceLabel.bottom - costtSize.height-1;
    
    _deleteLineView.y = costtSize.height/2;
    _deleteLineView.width = costtSize.width;
    _deleteLineView.height = 1;

}

- (void)addCountClick
{
    UIImageView *throwedView = [[UIImageView alloc]init];
    [throwedView setImage:[UIImage imageNamed:@"addActivate"]];
    throwedView.frame = _addIV.frame;
    throwedView.tag = 10;
    [self.contentView addSubview:throwedView];
    
    ThrowLineTool *throwLineTool = [ThrowLineTool sharedTool];
    throwLineTool.delegate = self;
    CartNumberLabel *cartNumberLabel = [CartNumberLabel shareCartNumberLabel];
    CGPoint cartLabelPoint = cartNumberLabel.center;
    cartLabelPoint = [cartNumberLabel.superview convertPoint:cartLabelPoint toView:self.contentView];
    
    [throwLineTool throwObject:throwedView from:_addIV.center to:cartLabelPoint height:40 duration:0.5];
    
    [UIView animateWithDuration:0.25 animations:^{
        cartNumberLabel.text = [NSString stringWithFormat:@"%zd",[cartNumberLabel.text integerValue] +1];
        _countLabel.text = [NSString stringWithFormat:@"%zd",[_countLabel.text integerValue] +1];
        cartNumberLabel.transform = CGAffineTransformScale(cartNumberLabel.transform, 2, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            cartNumberLabel.transform = CGAffineTransformScale(cartNumberLabel.transform, 0.5, 0.5);
        }];
    }];
    
}

- (void)animationDidFinish
{
    [[self.contentView viewWithTag:10] removeFromSuperview];
}

- (void)subCountClick
{
    NSLog(@"11222");
}

@end
