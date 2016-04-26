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
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _couponidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.contentView addSubview:_couponidLabel]; 
        _orderidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _couponidLabel.bottom, 320, 40)];
        [self.contentView addSubview:_orderidLabel]; 
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _orderidLabel.bottom, 320, 40)];
        [self.contentView addSubview:_statusLabel]; 
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _statusLabel.bottom, 320, 40)];
        [self.contentView addSubview:_typeLabel]; 
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _typeLabel.bottom, 320, 40)];
        [self.contentView addSubview:_titleLabel]; 
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, 320, 40)];
        [self.contentView addSubview:_subtitleLabel]; 
        _begintimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _subtitleLabel.bottom, 320, 40)];
        [self.contentView addSubview:_begintimeLabel]; 
        _endtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _begintimeLabel.bottom, 320, 40)];
        [self.contentView addSubview:_endtimeLabel]; 
        _minfeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _endtimeLabel.bottom, 320, 40)];
        [self.contentView addSubview:_minfeeLabel]; 
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _minfeeLabel.bottom, 320, 40)];
        [self.contentView addSubview:_moneyLabel]; 
        _discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _moneyLabel.bottom, 320, 40)];
        [self.contentView addSubview:_discountLabel]; 
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _discountLabel.bottom, 320, 40)];
        [self.contentView addSubview:_descriptionLabel]; 
        _discountmaxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _descriptionLabel.bottom, 320, 40)];
        [self.contentView addSubview:_discountmaxLabel];     }
    return self;
}

-(void) setModel:(CouponModel *)model
{
    [super setModel:model];

    _couponidLabel.text = [NSString stringWithFormat:@"%zd", model.couponId];
    _orderidLabel.text = [NSString stringWithFormat:@"%zd", model.orderid];
    _statusLabel.text = [NSString stringWithFormat:@"%zd", model.status];
    _typeLabel.text = [NSString stringWithFormat:@"%zd", model.type];
    _titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    _subtitleLabel.text = [NSString stringWithFormat:@"%@", model.subtitle];
    _begintimeLabel.text = [NSString stringWithFormat:@"%zd", model.begintime];
    _endtimeLabel.text = [NSString stringWithFormat:@"%zd", model.endtime];
    _minfeeLabel.text = [NSString stringWithFormat:@"%zd", model.minfee];
    _moneyLabel.text = [NSString stringWithFormat:@"%zd", model.money];
    _discountLabel.text = [NSString stringWithFormat:@"%zd", model.discount];
    _descriptionLabel.text = [NSString stringWithFormat:@"%@", model.description];
    _discountmaxLabel.text = [NSString stringWithFormat:@"%zd", model.discountmax];    
    self.height = _discountmaxLabel.bottom;
    model.cellHeight = self.height;
}
@end
