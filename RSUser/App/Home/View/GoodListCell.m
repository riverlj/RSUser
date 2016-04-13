//
//  RSHomeCell.m
//  RSUser
//
//  Created by WuRibatu on 15/10/26.
//  Copyright © 2015年 WuRibatu. All rights reserved.
//

#import "GoodListCell.h"
#import "GoodListModel.h"

@interface GoodListCell ()

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
    _iconIV = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_iconIV];
    
    [_iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [_iconIV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [_iconIV autoSetDimensionsToSize:CGSizeMake(71, 71)];
    _iconIV.layer.borderWidth = 0.5f;
    _iconIV.layer.borderColor = RS_Line_Color.CGColor;
    
    _saledLabel = [UILabel newAutoLayoutView];
    [_iconIV addSubview:_saledLabel];
    [_saledLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_saledLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_saledLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [_saledLabel autoSetDimension:ALDimensionHeight toSize:15];
    _saledLabel.backgroundColor = RS_Line_Color;
    _saledLabel.textAlignment = NSTextAlignmentCenter;
    _saledLabel.textColor = RS_TabBar_count_Color;
    _saledLabel.font = RS_SubLable_Font;
    
    _titleLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13];
    [_titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:12];
    _titleLabel.font = RS_SubLable_Font;
    _titleLabel.textColor = RS_Main_Text_Color;
    
    _menuLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_menuLabel];
    [_menuLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_titleLabel withOffset:10];
    [_menuLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:12];
    _menuLabel.font = RS_SubLable_Font;
    _menuLabel.textColor = RS_Sub_Text_Color;
    
    _priceLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_priceLabel];
    [_priceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconIV withOffset:12];
    [_priceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_menuLabel withOffset:10];
    _priceLabel.font = RS_PriceLable_Font;
    _priceLabel.textColor = RS_Theme_Color;
    
    _costPriceLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_costPriceLabel];
    [_costPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:150];
    [_costPriceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_menuLabel withOffset:14];
    _costPriceLabel.font = RS_CostPriceLable_Font;
    _costPriceLabel.textColor = RS_TabBar_Title_Color;
    
    UIView *lineView = [UIView newAutoLayoutView];
    [_costPriceLabel addSubview:lineView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [lineView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [lineView autoSetDimension:ALDimensionHeight toSize:1];
    lineView.backgroundColor = RS_TabBar_Title_Color;
    
    CGSize viewSize = CGSizeMake(40, 50);
    UIView *addView = [UIView newAutoLayoutView];
    [self.contentView addSubview:addView];
    [addView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [addView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [addView autoSetDimensionsToSize:viewSize];
    addView.userInteractionEnabled = YES;
    self.addView = addView;
    [self.addView addTapAction:@selector(addCountClick) target:self];
    
    CGSize addSize = [UIImage imageNamed:@"add"].size;
    _addIV = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_addIV];
    [_addIV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [_addIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_addIV autoSetDimensionsToSize:addSize];
    [_addIV setImage:[UIImage imageNamed:@"addActivate"]];
    
    _countLabel = [UILabel newAutoLayoutView];
    [self.contentView addSubview:_countLabel];
    [_countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_addIV withOffset:-12];
    [_countLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_countLabel autoSetDimension:ALDimensionWidth toSize:25];
    _countLabel.font = RS_CountLable_Font;
    _countLabel.textColor = RS_Sub_Text_Color;
    _countLabel.text = @"0";
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    
    UIView *subView = [UIView newAutoLayoutView];
    [self.contentView addSubview:subView];
    [subView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_countLabel];
    [subView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [subView autoSetDimensionsToSize:viewSize];
    subView.userInteractionEnabled = YES;
    self.subView = subView;
    [self.subView addTapAction:@selector(subCountClick) target:self];
    
    _subIV = [UIImageView newAutoLayoutView];
    [self.contentView addSubview:_subIV];
    [_subIV autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_countLabel withOffset:-12];
    [_subIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_subIV autoSetDimensionsToSize:addSize];
    [_subIV setImage:[UIImage imageNamed:@"subActivate"]];
}

- (void)setModel:(GoodListModel *)model
{
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    _titleLabel.text     = model.name;
    _menuLabel.text      = model.desc;
    _saledLabel.text     = [NSString stringWithFormat:@"已售%ld份", model.saled];
    _priceLabel.text     = [NSString stringWithFormat:@"￥%@", model.saleprice];
    _costPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
}

- (void)addCountClick
{
    
}

- (void)subCountClick
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
