//
//  OrderCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "OrderCell.h"
#import "OrderModel.h"

@implementation OrderCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _orderIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.contentView addSubview:_orderIdLabel]; 
        _oderdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _orderIdLabel.bottom, 320, 40)];
        [self.contentView addSubview:_oderdateLabel]; 
        _ordertimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _oderdateLabel.bottom, 320, 40)];
        [self.contentView addSubview:_ordertimeLabel]; 
        _statusidLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _ordertimeLabel.bottom, 320, 40)];
        [self.contentView addSubview:_statusidLabel]; 
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _statusidLabel.bottom, 320, 40)];
        [self.contentView addSubview:_statusLabel]; 
        _imgurlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _statusLabel.bottom, 320, 40)];
        [self.contentView addSubview:_imgurlLabel];     }
    return self;
}

-(void) setModel:(OrderModel *)model
{
    [super setModel:model];

    _orderIdLabel.text = [NSString stringWithFormat:@"%@", model.orderId];
    _oderdateLabel.text = [NSString stringWithFormat:@"%@", model.oderdate];
    _ordertimeLabel.text = [NSString stringWithFormat:@"%@", model.ordertime];
    _statusidLabel.text = [NSString stringWithFormat:@"%zd", model.statusid];
    _statusLabel.text = [NSString stringWithFormat:@"%@", model.status];
    _imgurlLabel.text = [NSString stringWithFormat:@"%@", model.imgurl];    
    self.height = _imgurlLabel.bottom;
    model.cellHeight = self.height;
}
@end
