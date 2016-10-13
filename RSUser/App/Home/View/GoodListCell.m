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
#import "XHStarRateView.h"

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
    
    //商品价格
    self.priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_Theme_Color FontSize:14];
    [self.contentView addSubview:self.priceLabel];
    
    CGSize addSize = [UIImage imageNamed:@"addActivate"].size;
    self.addIV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-addSize.width-10, 0, addSize.width+16, 49)];
    self.addIV.contentMode = UIViewContentModeLeft;
    [self.contentView addSubview:self.addIV];
    [self.addIV setImage:[UIImage imageNamed:@"addActivate"]];
    [self.addIV addTapAction:@selector(addCountClick) target:self];
    
    self.countLabel = [RSLabel lableViewWithFrame:CGRectMake(self.addIV.x- 38, self.addIV.top, 38, self.addIV.height) bgColor:[UIColor clearColor] textColor:RS_COLOR_NUMLABEL];
    self.countLabel.font = RS_FONT_F2;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.countLabel];
    
    self.subIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.countLabel.x-addSize.width, self.addIV.top, self.addIV.width, self.addIV.height)];
    [self.subIV setImage:[UIImage imageNamed:@"subActivate"]];
    self.subIV.contentMode = UIViewContentModeCenter;
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
    self.countLabel.text = [NSString stringWithFormat:@"%zd", _cartmodel.num];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
}

-(void)subCountClick
{
    [[Cart sharedCart] deleteGoods:_cartmodel];
    self.countLabel.text = [NSString stringWithFormat:@"%zd", _cartmodel.num];
 

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_UpadteCartCountLabel" object:nil userInfo:nil];
}

@end

@interface GoodListCell ()

@property (nonatomic,assign) NSInteger count;
@end

@implementation GoodListCell
{
    NSInteger maxCount;
    UIView *line;
}

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
    
    //已售数量
    self.saledLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_COLOR_C3];
    self.saledLabel.font = Font(9);
    [self.contentView addSubview:self.saledLabel];

    self.titleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_COLOR_C1];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.self.titleLabel.font = RS_FONT_F2;
    [self.contentView addSubview:self.self.titleLabel];
    
    //商品描述
    self.menuLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_COLOR_C2];
    self.menuLabel.textAlignment = NSTextAlignmentLeft;
    self.menuLabel.font = RS_FONT_F5;
    [self.contentView addSubview:self.menuLabel];
    
    self.priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:[UIColor clearColor] textColor:RS_Theme_Color];
    self.priceLabel.font = RS_FONT_F3;
    [self.contentView addSubview:self.priceLabel];
    
    CGSize addSize = [UIImage imageNamed:@"addActivate"].size;
    self.addIV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32, 93/2, 2*addSize.width, 93/2)];
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
    self.subIV.hidden = YES;
    [self.subIV addTapAction:@selector(subCountClick) target:self];
    [self.contentView addSubview:self.subIV];

    self.selloutLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.selloutLabel.textColor = RS_COLOR_C7;
    self.selloutLabel.backgroundColor = RS_COLOR_C4;
    self.selloutLabel.font = RS_FONT_F4;
    self.selloutLabel.layer.cornerRadius = 5;
    self.selloutLabel.layer.masksToBounds = YES;
    self.selloutLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.selloutLabel];
    
    //类别标签
    self.labelImageView = [RSImageView imageViewWithFrame:CGRectZero ImageName:@""];
    self.labelImageView.layer.cornerRadius = 0;
    self.labelImageView.layer.masksToBounds = YES;
    [self.iconIV addSubview:self.labelImageView];
    
    //新品
    self.newsImageView = [RSImageView imageViewWithFrame:CGRectZero ImageName:@"label_new"];
    self.newsImageView.hidden = YES;
    [self.contentView addSubview:self.newsImageView];
    
    //人气旺
    self.hotImageView = [RSImageView imageViewWithFrame:CGRectZero ImageName:@"label_hot"];
    self.hotImageView.hidden = YES;
    [self.contentView addSubview:self.hotImageView];
    
    //评价高
    self.highRateView = [RSImageView imageViewWithFrame:CGRectZero ImageName:@"label_highrate"];
    self.highRateView.hidden = YES;
    [self.contentView addSubview:self.highRateView];
    
    line = [RSLineView lineViewHorizontalWithFrame:CGRectZero Color:RS_Line_Color];
    line.hidden = YES;
    [self.contentView addSubview:line];
    
    self.lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 1) Color:RS_Line_Color];
    self.lineView.hidden = YES;
    [self.contentView addSubview:self.lineView];
}

- (void)setModel:(GoodListModel *)model
{
    _listModel = model;
    
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    self.countLabel.text = [NSString stringWithFormat:@"%zd", model.num];

    if (_listModel.num == 0) {
        self.addIV.hidden = NO;
        self.countLabel.hidden = YES;
        self.subIV.hidden =YES;
    } else {
        self.addIV.hidden = NO;
        self.countLabel.hidden = NO;
        self.subIV.hidden = NO;
    }
    
    if (_listModel.canbuymax == 0) {
        self.addIV.hidden = YES;
        self.subIV.hidden = YES;
    }
    
    self.lineView.hidden = model.hiddenLine;
    
    //类别标签
    NSString *imageName = [model getImageNameBytopcategoryid];
    self.labelImageView.image = [UIImage imageNamed:imageName];
    self.labelImageView.frame = CGRectMake(0, 0, 23, 23);
    
    //商品名称
    self.titleLabel.text = model.name;
    CGSize nameSize = [self.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.newsImageView.hidden = YES;
    if (model.isnew) {
        self.newsImageView.frame = CGRectMake(self.iconIV.right + 10, self.iconIV.top, 14, 14);
        self.newsImageView.hidden = NO;
        self.titleLabel.frame = CGRectMake(self.newsImageView.right+3, self.iconIV.top, nameSize.width, nameSize.height);
        self.titleLabel.centerY = self.newsImageView.centerY;
    }else {
        self.titleLabel.frame = CGRectMake(self.iconIV.right+10, self.iconIV.top, nameSize.width, nameSize.height);
        self.newsImageView.hidden = YES;
    }
    
    [self.starRateView removeFromSuperview];
    [self.scoreLabel removeFromSuperview];
    if ([model.ratescore integerValue] != 0) {
        self.starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(self.iconIV.right + 10, self.titleLabel.bottom + 4, 9*5+5*4, 9) foregroundStarImage:@"icon_home_star_yellow" backgroundStarImage:@"icon_home_star_gray" currentScore:[model.ratescore floatValue]];
        [self.contentView addSubview:self.starRateView];
        
        NSString *ratescore = [NSString stringWithFormat:@"%.1lf",[model.ratescore floatValue]];
        CGSize rateSize = [ratescore sizeWithFont:Font(12) byWidth:99999];
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.starRateView.right+2,  0, rateSize.width, rateSize.height)];
        self.scoreLabel.font = Font(12);
        self.scoreLabel.textColor = RS_Theme_Color;
        self.scoreLabel.text = ratescore;
        self.scoreLabel.bottom = self.starRateView.bottom+1;
        [self.contentView addSubview:self.scoreLabel];
    }
    
    //已售数量
    self.saledLabel.text = [NSString stringWithFormat:@"已售%zd份", model.saled];
    CGSize saledLabelSize = [self.saledLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (model.ratescore.integerValue == 0) {
        self.saledLabel.frame = CGRectMake(self.iconIV.right + 10, self.titleLabel.bottom + 4, saledLabelSize.width, saledLabelSize.height);
    }else {
        self.saledLabel.frame = CGRectMake(self.scoreLabel.right + 4, self.titleLabel.bottom + 4, saledLabelSize.width, saledLabelSize.height);
        self.saledLabel.centerY = self.starRateView.centerY;
    }
    
    //商品描述
    self.menuLabel.text = model.desc;
    CGSize menuLabelSize = [self.menuLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.menuLabel.frame = CGRectMake(self.iconIV.right + 10, self.saledLabel.bottom + 4, SCREEN_WIDTH-self.iconIV.right-10-80, menuLabelSize.height);
    

    //商品价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.saleprice];
    CGSize priceSize = [self.priceLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 40)];
    self.priceLabel.frame = CGRectMake(self.iconIV.right + 10, self.menuLabel.bottom+6, priceSize.width, priceSize.height);
    
    //评价高
    if (model.ishighrated) {
        self.highRateView.frame = CGRectMake(SCREEN_WIDTH-37-16, self.iconIV.top, 37, 13);
        self.highRateView.hidden = NO;
    }else {
        self.highRateView.hidden = YES;
    }
    
    //人气旺
    if (model.ishot) {
        self.hotImageView.frame = CGRectMake(self.highRateView.left-37-5, self.iconIV.top, 37, 13);
        self.hotImageView.hidden = NO;
    }else {
        self.hotImageView.hidden = YES;
    }
    if (model.ishot && !model.ishighrated) {
        self.hotImageView.x = SCREEN_WIDTH-37-16;
    }
    
    //已售罄
    self.selloutLabel.text = @"已售罄";
    self.selloutLabel.frame = CGRectMake(SCREEN_WIDTH-54-15, self.priceLabel.top, 54, 20);
    self.selloutLabel.centerY = self.priceLabel.centerY;
    self.selloutLabel.hidden = YES;
    if (_listModel.canbuymax == 0) {
        self.selloutLabel.hidden = NO;
    }
    
    //优惠信息
    NSArray *promotions = model.promotions;
    if (promotions.count > 0) {
        line.hidden = NO;
        line.x = self.iconIV.right+10;
        line.y = self.priceLabel.bottom+10;
        line.width =  SCREEN_WIDTH-self.iconIV.right -10;
    }else {
        line.hidden = YES;
    }
    CGFloat h = self.priceLabel.bottom;
    h += 20;
    
    if (promotions.count>maxCount) {
        maxCount = promotions.count;
    }
    for (int i=0; i<maxCount; i++) {
        [[self.contentView viewWithTag:(1000+i)] removeFromSuperview];
        [[self.contentView viewWithTag:(10000+i)] removeFromSuperview];
    }
    for (int i=0;  i<promotions.count; i++) {
        GoodListpromotion *promotion = promotions[i];
        NSString *imageName = [promotion getImageNameByType];
        UIImageView *actionImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        actionImageView.tag = 1000+i;
        actionImageView.frame = CGRectMake(self.iconIV.right + 10, h+4, 15, 15);
        actionImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:actionImageView];
        
        UILabel *label = [RSLabel labellWithFrame:CGRectMake(actionImageView.right+5, actionImageView.top, SCREEN_WIDTH-actionImageView.right-70, 15) Text:promotion.desc Font:Font(9) TextColor:[NSString colorFromHexString:@"818181"]];
        label.tag = 10000+i;
        [self.contentView addSubview:label];
        
        label.centerY = actionImageView.centerY;
        
        h = label.bottom;
        if (i==promotions.count-1) {
            h+=16;
        }
    }
    
    self.lineView.y = h;
    
    model.cellHeight = self.lineView.bottom;
}

- (void)countLabelClicked{}

- (void)addCountClick
{
    if (self.countLabel.text.integerValue >= self.listModel.canbuymax && self.listModel.canbuymax!=-1) {
        
        [[RSToastView shareRSToastView] showToast:@"库存不足啦，先买这么多吧～"];
        return;
    }

    ThrowLineTool *throwLineTool = [[ThrowLineTool alloc] init];
    CartNumberLabel *cartNumberLabel = [CartNumberLabel shareCartNumberLabel];

    CGPoint benginPoint = [self.addIV.superview convertPoint:self.addIV.center toView:nil];
    benginPoint.x -= 10;
    CGPoint endpoint = [cartNumberLabel.superview convertPoint:cartNumberLabel.center toView:nil];
    
    [throwLineTool throwObject:nil from:benginPoint to:endpoint height:40 duration:0.5];
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd",[self.countLabel.text integerValue] +1];
    
    if ([self.countLabel.text integerValue] > 0)
    {
        self.subIV.hidden = NO;
        self.countLabel.hidden = NO;
    }
    
    [[Cart sharedCart] addGoods:_listModel];
     [[Cart sharedCart] updateCartCountLabelText];
    
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
