//
//  CouponCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-26.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "CouponCell.h"
#import "CouponModel.h"

@implementation CouponCell
{
    UIImageView *bgView;
}
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor =  RS_Background_Color;

        
        bgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 10, SCREEN_WIDTH - 36, (SCREEN_WIDTH - 36) * 100/340)];
        [self.contentView addSubview:bgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, bgView.width-120-18, 12)];
        _titleLabel.font = RS_SubLable_Font;
        _titleLabel.textColor = RS_SubMain_Text_Color;
        [bgView addSubview:_titleLabel];
       
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 5, _titleLabel.width, 12)];
        _descriptionLabel.font = RS_SubLable_Font;
        _descriptionLabel.textColor = RS_SubMain_Text_Color;
        [bgView addSubview:_descriptionLabel];
        
        _begintimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left -30, 0, 95, 9)];
        _begintimeLabel.textColor = RS_SubMain_Text_Color;
        _begintimeLabel.font = RS_CostPriceLable_Font;
        _begintimeLabel.bottom = bgView.height - 15;
        [bgView addSubview:_begintimeLabel];
        
        
        _endtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_begintimeLabel.left, _begintimeLabel.top, _begintimeLabel.width, 9)];
        _endtimeLabel.textColor = RS_SubMain_Text_Color;
        _endtimeLabel.font = RS_CostPriceLable_Font;
        _endtimeLabel.left = _begintimeLabel.right + 10;
        [bgView addSubview:_endtimeLabel];

        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
        _moneyLabel.centerY = bgView.height/2;
        _moneyLabel.font = Font(45);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_moneyLabel];
       
        
    }
    return self;
}

-(void) setModel:(CouponModel *)model
{
    [super setModel:model];

    _titleLabel.text = [NSString stringWithFormat:@"• %@", model.title];
    _begintimeLabel.text = [NSString stringWithFormat:@"开始日期:%@", [model getBeginDate]];
    _endtimeLabel.text = [NSString stringWithFormat:@"截止日期:%@", [model getEndDate]];
    _moneyLabel.text = [NSString stringWithFormat:@"￥%zd", model.money];
    _descriptionLabel.text = [NSString stringWithFormat:@"• %@", model.descriptionstr];
    [_descriptionLabel setGrowthText:[NSString stringWithFormat:@"• %@", model.descriptionstr]];
    if(_descriptionLabel.height > 40) {
        _descriptionLabel.height = 40;
    }
    if(model.status == CouponModelStatusNew) {
        bgView.image = [UIImage imageNamed:@"bg_coupon_red"];
        _moneyLabel.textColor = RS_Theme_Color;
        self.userInteractionEnabled = YES;
    } else {
        bgView.image = [UIImage imageNamed:@"bg_coupon_gray"];
        _moneyLabel.textColor = RS_SubMain_Text_Color;
        self.userInteractionEnabled = NO;
    }
    self.height = _descriptionLabel.bottom;
    model.cellHeight = self.height;
}
@end
