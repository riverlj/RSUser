//
//  OrderCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _orderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, 71, 71)];
        [self.contentView addSubview:_orderImageView];
        
        _orderdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderImageView.right+12.5, 15, 0, 0)];
        _orderdateLabel.font = RS_FONT_F2;
        _orderdateLabel.textColor = RS_COLOR_C2;
        [self.contentView addSubview:_orderdateLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_orderdateLabel.x, 0, 0, 0)];
        _statusLabel.font = RS_FONT_F4;
        _statusLabel.textColor = [NSString colorFromHexString:@"5faaff"];
        [self.contentView addSubview:_statusLabel];
        
        _statusButton = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-88, 27.5, 70, 26) ImageName:nil Text:@"" TextColor:nil];
        _statusButton.layer.cornerRadius = 4;
        _statusButton.layer.borderWidth = 1;
        _statusButton.titleLabel.font = RS_FONT_F3;
        [_statusButton addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_statusButton];
        
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender
{
    
    if (_orderModel.statusid == 0) {
        if (self.cellBtnClickedDelegate && [_cellBtnClickedDelegate respondsToSelector:@selector(goPay)] ) {
            [_cellBtnClickedDelegate goPay];
        }
    }else{
        if (self.cellBtnClickedDelegate && [_cellBtnClickedDelegate respondsToSelector:@selector(goOrderInfo:)] ) {
            [_cellBtnClickedDelegate goOrderInfo:self.orderModel.orderId];
        }
    }
}

-(void) setModel:(OrderModel *)model
{
    [super setModel:model];
    _orderModel = model;

    [_orderImageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl]];
    
    NSDate *date = [NSDate dateFromString:model.orderdate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *orderDate = [formatter stringFromDate:date];
    
    _orderdateLabel.text = [NSString stringWithFormat:@"%@", orderDate];
    CGSize dataSize = [_orderdateLabel sizeThatFits:CGSizeMake(1000, 1000)];
    _orderdateLabel.width = dataSize.width;
    _orderdateLabel.height = dataSize.height;
    
    _statusLabel.text = [NSString stringWithFormat:@"%@", model.status];
    CGSize statusSize = [_orderdateLabel sizeThatFits:CGSizeMake(1000, 1000)];
    _statusLabel.width = statusSize.width;
    _statusLabel.height = statusSize.height;
    _statusLabel.y =  _orderdateLabel.bottom + 10;

    if (model.statusid == 0) {
        [_statusButton setTitle:@"支付" forState:UIControlStateNormal];
        _statusButton.layer.borderColor = RS_Theme_Color.CGColor;
        [_statusButton setTitleColor:RS_Theme_Color forState:UIControlStateNormal];
    }else{
        [_statusButton setTitle:@"查看" forState:UIControlStateNormal];
        _statusButton.layer.borderColor = RS_COLOR_C8.CGColor;
        [_statusButton setTitleColor:RS_COLOR_C8 forState:UIControlStateNormal];
    }
    
    model.cellHeight = 81;
}


@end
