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
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(109*(SCREEN_WIDTH/320), 12, bgView.width-109-20, 10)];
        _titleLabel.font = Font(10);
        _titleLabel.textColor = RS_SubMain_Text_Color;
        [bgView addSubview:_titleLabel];
       
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, _titleLabel.bottom + 4, _titleLabel.width, 10)];
        _descriptionLabel.font = Font(10);
        _descriptionLabel.textColor = RS_SubMain_Text_Color;
        [bgView addSubview:_descriptionLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.left, 0, _titleLabel.width, 9)];
        _timeLabel.textColor = RS_SubMain_Text_Color;
        _timeLabel.font = RS_CostPriceLable_Font;
        _timeLabel.bottom = bgView.height - 12;
        [bgView addSubview:_timeLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80*(SCREEN_WIDTH/320), 30)];
        _moneyLabel.centerY = bgView.height/2;
        _moneyLabel.font = Font(45);
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_moneyLabel];
       
        _remainLabel = [[UILabel alloc] initWithFrame:CGRectMake(_moneyLabel.left, _moneyLabel.bottom + 3, _moneyLabel.width, 9)];
        _remainLabel.textColor = RS_Theme_Color;
        _remainLabel.font = Font(9);
        _remainLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_remainLabel];
        
    }
    return self;
}

-(void) setModel:(CouponModel *)model
{
    [super setModel:model];

    _titleLabel.text = [NSString stringWithFormat:@"• %@", model.title];
    _timeLabel.text = [NSString stringWithFormat:@"可用日期:%@~%@", [model getBeginDate], [model getEndDate]];
    _moneyLabel.attributedText =  [model getMoneyStr];
    _descriptionLabel.text = [NSString stringWithFormat:@"• %@", model.descriptionstr];
    [_descriptionLabel setGrowthText:[NSString stringWithFormat:@"• %@", model.descriptionstr]];
    if(_descriptionLabel.height > 40) {
        _descriptionLabel.height = 40;
    }
    if([model.fromtype isEqualToString:@"canuse"]) {
        bgView.image = [UIImage imageNamed:@"bg_coupon_red"];
        _moneyLabel.textColor = RS_Theme_Color;
        self.userInteractionEnabled = YES;
        _moneyLabel.textColor = _remainLabel.textColor = RS_Theme_Color;
        _titleLabel.textColor = _descriptionLabel.textColor = RS_SubMain_Text_Color;
        _timeLabel.textColor = RS_TabBar_Title_Color;
        _remainLabel.text = [model getRemainStr];
    } else {
        bgView.image = [UIImage imageNamed:@"bg_coupon_gray"];
        _moneyLabel.textColor = RS_SubMain_Text_Color;
        self.userInteractionEnabled = NO;
        _moneyLabel.textColor = _remainLabel.textColor = _titleLabel.textColor = _descriptionLabel.textColor = _timeLabel.textColor = [NSString colorFromHexString:@"afafaf"];
        _remainLabel.text = @"";
    }
    self.height = _descriptionLabel.bottom;

    model.cellHeight = self.height;
}
@end
