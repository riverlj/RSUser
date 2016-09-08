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

static const CGFloat kcategaryHeight = 35;
static const CGFloat kcellMarginRight = 15;

@interface ConfirmGoodDetailCell()
{
    Boolean isReWrite;
    UIImageView *arrowimageView;
}
@end
@implementation ConfirmGoodDetailCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        isReWrite = NO;
        
        //品类图片
        self.categoryImageView = [RSImageView imageViewWithFrame:CGRectZero ImageName:@""];
        self.categoryImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.categoryImageView];
        
        //品类名称
        self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.categoryLabel.font = RS_BOLDFONT_F3;
        self.categoryLabel.textColor = RS_COLOR_C1;
        self.categoryLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.categoryLabel];
        
        //配送时间
        self.sendTimeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.sendTimeLabel addTapAction:@selector(selcectTime:) target:self];
        self.sendTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.sendTimeLabel.font = RS_FONT_F4;
        self.sendTimeLabel.textColor = RS_Theme_Color;
        self.sendTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.sendTimeLabel];
        
        //箭头
        arrowimageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kcellMarginRight-6, self.categoryImageView.top, 6, 10)];
        arrowimageView.image = [UIImage imageNamed:@"cart_arrow"];
        [self.contentView addSubview:arrowimageView];
        
        self.categoryLineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(kcellMarginRight, kcategaryHeight-1, SCREEN_WIDTH-kcellMarginRight, 1) Color:RS_Line_Color];
        [self.contentView addSubview:self.categoryLineView];
        
        self.cellLineView =[RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kcellMarginRight, 1) Color:RS_Line_Color];
        self.cellLineView.hidden = YES;
        [self.contentView addSubview:self.cellLineView];
    }
    return self;
}

- (void)selcectTime:(UIGestureRecognizer *)sender {
    
}

- (void)setData:(ConfirmOrderDetailViewModel *)model
{
    self.confirmOrderDetailViewModel = model;
    NSString *imageName = @"";
    if ([model.categoryName isEqualToString:@"早餐"]) {
         imageName = @"order_icon_breakfast";
    }else if ([model.categoryName isEqualToString:@"午餐"]) {
         imageName = @"order_icon_lunch";
    }else if ([model.categoryName isEqualToString:@"水果"]) {
         imageName = @"order_icon_fruit";
    }
    
    //品类图标
    self.categoryImageView.image = [UIImage imageNamed:imageName];
    self.categoryImageView.frame = CGRectMake(kcellMarginRight, 0, 14, kcategaryHeight);
    
    self.categoryLabel.text = [NSString stringWithFormat:@"%@详情",model.categoryName];
    self.sendTimeLabel.text = model.sendTimeDes;
    
    //类别名
    CGSize categoryLableSize = [self.categoryLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.categoryLabel.frame = CGRectMake(self.categoryImageView.right+3, 0, categoryLableSize.width, kcategaryHeight);
    
    //配送时间
    CGSize sendTimeLabelSize = [self.sendTimeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.sendTimeLabel.width = sendTimeLabelSize.width;
    self.sendTimeLabel.height = kcategaryHeight;
    self.sendTimeLabel.x = SCREEN_WIDTH - 18 - 6 - self.sendTimeLabel.width;
    self.sendTimeLabel.y = 0;
    [self.sendTimeLabel addTapAction:@selector(selectSendTime:) target:self];
    
    self.categoryLabel.centerY = self.categoryImageView.centerY;
    self.sendTimeLabel.centerY = self.categoryImageView.centerY;
    arrowimageView.centerY = self.categoryImageView.centerY;

    NSArray *gifts = model.gifts;
    
    CGFloat h ;
    NSArray *goods = model.goods;
    
    if ([model.viewType isEqualToString:@"orderinfoview"]) {
        h = self.categoryLabel.bottom;
        for (int i=0; i < goods.count; i++) {
            GoodListModel *goodListModel = goods[i];
            
            if (goodListModel.gift != 0) {
                h += 6;
                UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.categoryLabel.left, h, 15, 15)];
                iconImageView.image = [UIImage imageNamed:@"icon_zeng"];
                [self.contentView addSubview:iconImageView];
                
                RSLabel *goodNameLbel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C3];
                goodNameLbel.textAlignment = NSTextAlignmentLeft;
                goodNameLbel.font = RS_FONT_F5;
                goodNameLbel.text = goodListModel.name;
                [self.contentView addSubview:goodNameLbel];
                
                RSLabel *priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C3];
                priceLabel.font = RS_FONT_F5;
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.text =[NSString stringWithFormat:@"¥%@ × %zd",goodListModel.saleprice,goodListModel.num];
                [self.contentView addSubview:priceLabel];
                
                CGSize priceSize = [priceLabel sizeThatFits:CGSizeMake(1000, 1000)];
                priceLabel.frame = CGRectMake(0, h, priceSize.width, 30);
                priceLabel.x = SCREEN_WIDTH - 18 - priceSize.width;
                
                CGSize goodNameLbelSize = [goodNameLbel sizeThatFits:CGSizeMake(1000, 1000)];
                goodNameLbel.frame = CGRectMake(iconImageView.right+3, h, priceLabel.x - 30, goodNameLbelSize.height);
                goodNameLbel.centerY = iconImageView.centerY;
                priceLabel.centerY = goodNameLbel.centerY;
                h = goodNameLbel.bottom;
            }else{
                if (i==0) {
                    h+=12;
                }else {
                    h+=10;
                }
                RSLabel *goodNameLbel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C2];
                goodNameLbel.textAlignment = NSTextAlignmentLeft;
                goodNameLbel.font = RS_FONT_F4;
                goodNameLbel.text = goodListModel.name;
                [self.contentView addSubview:goodNameLbel];
                
                RSLabel *priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C2];
                priceLabel.font = RS_FONT_F4;
                priceLabel.textAlignment = NSTextAlignmentRight;
                priceLabel.text =[NSString stringWithFormat:@"¥%@ × %zd",goodListModel.saleprice,goodListModel.num];
                [self.contentView addSubview:priceLabel];
                
                CGSize priceSize = [priceLabel sizeThatFits:CGSizeMake(1000, 1000)];
                priceLabel.frame = CGRectMake(0, h, priceSize.width, 30);
                priceLabel.x = SCREEN_WIDTH - 18 - priceSize.width;
                
                CGSize goodNameLbelSize = [goodNameLbel sizeThatFits:CGSizeMake(1000, 1000)];
                goodNameLbel.frame = CGRectMake(self.categoryLabel.left, h, priceLabel.x - 30, goodNameLbelSize.height);
                priceLabel.centerY = goodNameLbel.centerY;
                h = goodNameLbel.bottom ;
                
            }
        }
        
    }else {
        h = self.categoryLabel.bottom + 12;
        NSMutableArray *gitfsArray = [[NSMutableArray alloc] init];
        for (int i=0; i<gifts.count; i++) {
            GiftPromotionModel *giftPromotionModel = gifts[i];
            NSDictionary *gift = giftPromotionModel.gift;
            NSArray *keyArray = [gift allKeys];
            for (int i=0; i<keyArray.count; i++) {
                NSDictionary *gitfdic = [gift valueForKey:keyArray[i]];
                GiftModel *giftModel = [[GiftModel alloc] init];
                giftModel.gift_amount = [[gitfdic valueForKey:@"gift_amount"] integerValue];
                giftModel.gift_name = [gitfdic valueForKey:@"gift_name"];
                giftModel.masterid = [[gitfdic valueForKey:@"master"] integerValue];
                [gitfsArray addObject:giftModel];

            }
        }

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
            
            CGSize goodNameLbelSize = [goodNameLbel sizeThatFits:CGSizeMake(1000, 1000)];
            goodNameLbel.frame = CGRectMake(self.categoryLabel.left, h, priceLabel.x - 30, goodNameLbelSize.height);
            priceLabel.centerY = goodNameLbel.centerY;
            
            h = goodNameLbel.bottom;

            for (int j=0; j<gitfsArray.count; j++) {
                GiftModel *giftModel = gitfsArray[j];
                if (goodListModel.comproductid == giftModel.masterid) {
                    h+=6;
                    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(goodNameLbel.left, h, 15, 15)];
                    iconImageView.image = [UIImage imageNamed:@"icon_zeng"];
                    [self.contentView addSubview:iconImageView];
                    
                    RSLabel *giftgoodNameLbel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C3];
                    giftgoodNameLbel.textAlignment = NSTextAlignmentLeft;
                    giftgoodNameLbel.font = Font(9);
                    giftgoodNameLbel.text = giftModel.gift_name;
                    [self.contentView addSubview:giftgoodNameLbel];
                    
                    RSLabel *giftpriceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C3];
                    giftpriceLabel.font = Font(9);
                    giftpriceLabel.textAlignment = NSTextAlignmentRight;
                    giftpriceLabel.text =[NSString stringWithFormat:@"¥%@ × %ld",@"0.00",giftModel.gift_amount];
                    [self.contentView addSubview:giftpriceLabel];
                    
                    CGSize giftpriceSize = [giftpriceLabel sizeThatFits:CGSizeMake(1000, 1000)];
                    giftpriceLabel.frame = CGRectMake(0, iconImageView.top, giftpriceSize.width, 30);
                    giftpriceLabel.x = SCREEN_WIDTH - 18 - giftpriceSize.width;
                    
                    CGSize giftgoodNameLbelSize = [giftgoodNameLbel sizeThatFits:CGSizeMake(1000, 1000)];
                    giftgoodNameLbel.frame = CGRectMake(iconImageView.right+3, iconImageView.top, giftpriceLabel.x - 30, giftgoodNameLbelSize.height);
                    
                    giftgoodNameLbel.centerY = iconImageView.centerY;
                    giftpriceLabel.centerY = iconImageView.centerY;
                    
                    h = iconImageView.bottom;
                }
            }
            
            if (i!=goods.count-1) {
                h+=10;
            }
        }
    }
    
    h += 13;
    if (model.inOderDetail) {
        arrowimageView.hidden = YES;
        self.sendTimeLabel.textColor = RS_COLOR_C2;
        self.sendTimeLabel.x = SCREEN_WIDTH - self.sendTimeLabel.width - 18;
    }

    self.cellLineView.hidden = model.cellLineHidden;
    if (!self.cellLineView.hidden) {
        self.cellLineView.y = h - 1;
    }

    model.cellHeight = h;
    
}

- (void)selectSendTime:(UIGestureRecognizer *)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedSendTimeWithCategoryid:withTimeLable:)]) {
        [self.delegate selectedSendTimeWithCategoryid:self.confirmOrderDetailViewModel.categoryid withTimeLable:self.sendTimeLabel];
    }
}
@end
