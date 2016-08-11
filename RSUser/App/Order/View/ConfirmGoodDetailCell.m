//
//  ConfirmGoodDetailCell.m
//  RSUser
//
//  Created by 李江 on 16/8/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ConfirmGoodDetailCell.h"
#import "PromotionModel.h"
#import "GoodListModel.h"

@interface ConfirmGoodDetailCell()
{
    Boolean isReWrite;
}
@end
@implementation ConfirmGoodDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        isReWrite = NO;
        self.categoryImageView = [RSImageView imageViewWithFrame:CGRectMake(10, 15, 14, 14) ImageName:@""];
        [self.contentView addSubview:self.categoryImageView];
        
        self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.categoryImageView.right+3, self.categoryImageView.top, 0, 0)];
        self.categoryLabel.font = RS_BOLDFONT_F3;
        self.categoryLabel.textColor = RS_COLOR_C1;
        [self.contentView addSubview:self.categoryLabel];
        
        self.sendTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.sendTimeLabel addTapAction:@selector(selcectTime:) target:self];
        self.sendTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.sendTimeLabel.font = RS_FONT_F4;
        self.sendTimeLabel.textColor = RS_Theme_Color;
        [self.contentView addSubview:self.sendTimeLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-18, self.categoryImageView.top, 6, 10)];
        imageView.image = [UIImage imageNamed:@"cart_arrow"];
        imageView.centerY = self.categoryImageView.centerY;
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)selcectTime:(UIGestureRecognizer *)sender {
    
}

- (void)setData:(ConfirmOrderDetailViewModel *)model
{
    self.confirmOrderDetailViewModel = model;
    if ([model.categoryName isEqualToString:@"早餐"]) {
        self.categoryImageView.image = [UIImage imageNamed:@"order_icon_breakfast"];
    }else if ([model.categoryName isEqualToString:@"午餐"]) {
        self.categoryImageView.image = [UIImage imageNamed:@"order_icon_lunch"];
    }else if ([model.categoryName isEqualToString:@"水果"]) {
        self.categoryImageView.image = [UIImage imageNamed:@"order_icon_fruit"];
    }
    self.categoryLabel.text = [NSString stringWithFormat:@"%@详情",model.categoryName];
    self.sendTimeLabel.text = model.sendTimeDes;
    
    CGSize categoryLableSize = [self.categoryLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.categoryLabel.width = categoryLableSize.width;
    self.categoryLabel.height = categoryLableSize.height;
    
    
    CGSize sendTimeLabelSize = [self.sendTimeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.sendTimeLabel.width = sendTimeLabelSize.width;
    self.sendTimeLabel.height = sendTimeLabelSize.height;
    self.sendTimeLabel.x = SCREEN_WIDTH - 18 - 6 - 4 - self.sendTimeLabel.width;
    self.sendTimeLabel.y = self.categoryImageView.top;
    [self.sendTimeLabel addTapAction:@selector(selectSendTime:) target:self];
    
    self.categoryLabel.centerY = self.categoryImageView.centerY;
    self.sendTimeLabel.centerY = self.categoryImageView.centerY;
    
    CGFloat h = self.categoryLabel.bottom + 15;
    NSArray *goods = model.goods;
    for (int i=0; i < goods.count; i++) {
        GoodListModel *goodListModel = goods[i];
        RSLabel *goodNameLbel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C2];
        goodNameLbel.textAlignment = NSTextAlignmentLeft;
        goodNameLbel.font = RS_FONT_F4;
        goodNameLbel.text = goodListModel.name;
        [self.contentView addSubview:goodNameLbel];
        
        RSLabel *priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C2];
        priceLabel.font = RS_FONT_F4;
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text =[NSString stringWithFormat:@"¥%@ × %ld",goodListModel.saleprice,goodListModel.num];
        [self.contentView addSubview:priceLabel];
        
        CGSize priceSize = [priceLabel sizeThatFits:CGSizeMake(1000, 1000)];
        priceLabel.frame = CGRectMake(0, h, priceSize.width, 30);
        priceLabel.x = SCREEN_WIDTH - 18 - priceSize.width;
        
        CGSize goodNameLbelSize = [priceLabel sizeThatFits:CGSizeMake(1000, 1000)];
        goodNameLbel.frame = CGRectMake(self.categoryLabel.left, h, priceLabel.x - 30, goodNameLbelSize.height);
        
        h = goodNameLbelSize.height + h + 10;
    }

    model.cellHeight = h;
}

- (void)selectSendTime:(UIGestureRecognizer *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedSendTimeWithCategoryid:withTimeLable:)]) {
        [self.delegate selectedSendTimeWithCategoryid:self.confirmOrderDetailViewModel.categoryid withTimeLable:self.sendTimeLabel];
    }
}
@end
