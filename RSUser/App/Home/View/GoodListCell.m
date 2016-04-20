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
    self.titleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_MainLable_Text_Color];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = Font(14);
    [self.contentView addSubview:self.titleLabel];
    
    self.priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_Theme_Color FontSize:14];
    [self.contentView addSubview:self.priceLabel];
    
    CGSize addSize = [UIImage imageNamed:@"add"].size;
    self.addIV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, 16.5, addSize.width, addSize.height)];
    [self.contentView addSubview:self.addIV];
    [self.addIV setImage:[UIImage imageNamed:@"addActivate"]];
    [self.addIV addTapAction:@selector(addCountClick) target:self];
    
    self.countLabel = [RSLabel lableViewWithFrame:CGRectMake(self.addIV.x- 38, self.addIV.top, 38, self.addIV.height) bgColor:[UIColor clearColor] textColor:RS_NumbLabel_Text_Color];
    self.countLabel.font = RS_MainLable_Font;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.countLabel];
    
    self.subIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.countLabel.x-addSize.width, self.addIV.top, self.addIV.width, self.addIV.height)];
    [self.subIV setImage:[UIImage imageNamed:@"subActivate"]];
    [self.contentView addSubview:self.subIV];
    [self.subIV addTapAction:@selector(subCountClick) target:self];
}

-(void)setModel:(CartModel *)model
{
    _cartmodel = model;
    self.titleLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.countLabel.text = [NSString stringWithFormat:@"%zd", model.num];
    [self setFramesWithModel:model];
}

- (void)setFramesWithModel:(CartModel *)model
{
    self.titleLabel.frame = CGRectMake(18, 0, SCREEN_WIDTH/2-20, 49);
    CGSize priceSize = [self.priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, self.titleLabel.height)];
    self.priceLabel.frame = CGRectMake(SCREEN_WIDTH/2, 0, priceSize.width, _titleLabel.height);
}

- (void)addCountClick
{
    _cartmodel.num ++;
    self.countLabel.text = [NSString stringWithFormat:@"%zd", _cartmodel.num];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
}

-(void)subCountClick
{
    _cartmodel.num --;
    self.countLabel.text = [NSString stringWithFormat:@"%zd", _cartmodel.num];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
}

@end

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

    self.titleLabel = [RSLabel lableViewWithFrame:CGRectMake(_iconIV.right + 12, 15, SCREEN_WIDTH-_iconIV.right - 30, 0) bgColor:[UIColor clearColor] textColor:RS_MainLable_Text_Color];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.self.titleLabel.font = RS_MainLable_Font;
    [self.contentView addSubview:self.self.titleLabel];
    
    _menuLabel = [RSLabel lableViewWithFrame:CGRectMake(self.titleLabel.x, 0, self.titleLabel.width, 0) bgColor:[UIColor clearColor] textColor:RS_Sub_Text_Color];
    _menuLabel.textAlignment = NSTextAlignmentLeft;
    _menuLabel.font = RS_SubLable_Font;
    [self.contentView addSubview:_menuLabel];
    
    self.priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_Theme_Color];
    self.priceLabel.font = RS_PriceLable_Font;
    [self.contentView addSubview:self.priceLabel];
    
    _costPriceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_SubMain_Text_Color];
    _costPriceLabel.font = RS_CostPriceLable_Font;
    [self.contentView addSubview:_costPriceLabel];
    
    _deleteLineView = [[UIView alloc]init];
    [_costPriceLabel addSubview:_deleteLineView];
    _deleteLineView.backgroundColor = RS_SubMain_Text_Color;
    
    CGSize addSize = [UIImage imageNamed:@"add"].size;
    self.addIV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, 62, addSize.width, addSize.height)];
    [self.contentView addSubview:self.addIV];
    [self.addIV setImage:[UIImage imageNamed:@"addActivate"]];
    [self.addIV addTapAction:@selector(addCountClick) target:self];
    
    self.countLabel = [RSLabel lableViewWithFrame:CGRectMake(self.addIV.x- 38, self.addIV.top, 38, self.addIV.height) bgColor:[UIColor clearColor] textColor:RS_NumbLabel_Text_Color];
    self.countLabel.font = RS_MainLable_Font;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    self.countLabel.hidden = YES;
    [self.contentView addSubview:self.countLabel];
    
    self.subIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.countLabel.x-addSize.width, self.addIV.top, self.addIV.width, self.addIV.height)];
    [self.subIV setImage:[UIImage imageNamed:@"subActivate"]];
    [self.contentView addSubview:self.subIV];
    self.subIV.hidden = YES;
    [self.subIV addTapAction:@selector(subCountClick) target:self];
    
    [self addObserver];
}

- (void)addObserver
{
    [RACObserve(self.countLabel, text) subscribeNext:^(NSString *text) {
        _listModel.num = [text integerValue];
    }];
}

- (void)setModel:(GoodListModel *)model
{
    _listModel = model;
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    self.titleLabel.text     = model.name;
    _menuLabel.text      = model.desc;
    _saledLabel.text     = [NSString stringWithFormat:@"已售%ld份", model.saled];
    self.priceLabel.text     = [NSString stringWithFormat:@"￥%@", model.saleprice];
    _costPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.countLabel.text = [NSString stringWithFormat:@"%zd", model.num];
    if (_listModel.num == 0)
    {
        self.countLabel.hidden = YES;
        self.subIV.hidden =YES;
    }
    else
    {
        self.countLabel.hidden = NO;
        self.subIV.hidden =NO;
    }
    
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
    
    _costPriceLabel.x = self.priceLabel.right + 5;
    CGSize costtSize = [_costPriceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    _costPriceLabel.size = costtSize;
    _costPriceLabel.y = self.priceLabel.bottom - costtSize.height-1;
    
    _deleteLineView.y = costtSize.height/2;
    _deleteLineView.width = costtSize.width;
    _deleteLineView.height = 1;

}

- (void)addCountClick
{
    UIImageView *throwedView = [[UIImageView alloc]init];
    [throwedView setImage:[UIImage imageNamed:@"addActivate"]];
    throwedView.frame = self.addIV.frame;
    throwedView.tag = 10;
    [self.contentView addSubview:throwedView];
    
    ThrowLineTool *throwLineTool = [ThrowLineTool sharedTool];
    throwLineTool.delegate = self;
    CartNumberLabel *cartNumberLabel = [CartNumberLabel shareCartNumberLabel];
    CGPoint cartLabelPoint = cartNumberLabel.center;
    cartLabelPoint = [cartNumberLabel.superview convertPoint:cartLabelPoint toView:self.contentView];
    
    [throwLineTool throwObject:throwedView from:self.addIV.center to:cartLabelPoint height:40 duration:0.5];
    
    [UIView animateWithDuration:0.25 animations:^{
        cartNumberLabel.text = [NSString stringWithFormat:@"%zd",[cartNumberLabel.text integerValue] +1];
        self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] +1];
        cartNumberLabel.transform = CGAffineTransformScale(cartNumberLabel.transform, 2, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            cartNumberLabel.transform = CGAffineTransformScale(cartNumberLabel.transform, 0.5, 0.5);
        }];
    }];
    
    if ([self.countLabel.text integerValue] > 0)
    {
        self.subIV.hidden = NO;
        self.countLabel.hidden = NO;
    }
    
    [self addGoodsToCart];
    
}

- (void)animationDidFinish
{
    [[self.contentView viewWithTag:10] removeFromSuperview];
}

- (void)subCountClick
{
    CartNumberLabel *cartNumberLabel = [CartNumberLabel shareCartNumberLabel];
    cartNumberLabel.text =[NSString stringWithFormat:@"%zd", ([cartNumberLabel.text integerValue] -1) ];
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] -1];
    if ([self.countLabel.text integerValue] == 0)
    {
        self.subIV.hidden = YES;
        self.countLabel.hidden = YES;
    }
    
    [self subGoodsFromCart];
}


- (void)addGoodsToCart
{
    NSMutableArray *cartArray = [AppConfig getLocalCartData];
    BOOL isExist = NO;
    for (int i=0; i<cartArray.count; i++)
    {
        CartModel *model = cartArray[i];
        if (model.comproductid == _listModel.comproductid)
        {
            isExist = YES;
            model.num++;
            break;
        }
    }
    
    if (!isExist || cartArray.count == 0)
    {
        CartModel *model = [[CartModel alloc]init];
        model.cellHeight = 49;
        model.cellClassName = @"CartCell";
        model.comproductid = _listModel.comproductid;
        model.name = _listModel.name;
        model.num = 1;
        model.price = _listModel.price;
        [cartArray addObject:model];
    }
    
    [AppConfig saveLocalCartData];
}

- (void)subGoodsFromCart
{
    NSMutableArray *cartArray = [AppConfig getLocalCartData];
    NSInteger index = -1;
    for (int i=0; i<cartArray.count; i++)
    {
        CartModel *model = cartArray[i];
        if (model.comproductid == _listModel.comproductid)
        {
            model.num --;
            if (model.num == 0)
            {
                index = i;
            }
            break;
        }
    }
    
    if (index != -1)
    {
        [cartArray removeObjectAtIndex:index];
    }
    
    [AppConfig saveLocalCartData];
}

@end
