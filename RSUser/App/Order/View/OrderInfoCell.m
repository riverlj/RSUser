//
//  OrderInfoCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-28.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "OrderInfoCell.h"
#import "OrderInfoModel.h"


@implementation OrderInfoCell

@end

/**
 * 只含有一行字的cell
 */
@implementation TitleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title = [RSLabel labelOneLevelWithFrame:CGRectZero Text:nil];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)setModel:(OrderInfoModel *)model
{
    _title.text = [NSString stringWithFormat:@"送达时间:  %@  (早%@-%@)", @(model.subscribetime), model.fastesttime, model.lastesttime];
    _title.frame = CGRectMake(18, 0, SCREEN_WIDTH-36, 49);
    
    self.lineView = [RSLineView lineViewHorizontal];
    self.lineView.x = 18;
    self.lineView.y = 48;
    [self.contentView addSubview:self.lineView];
}
@end

/**
 * 订单详情cell
 */
@implementation OrderInfoDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _detailLabel = [RSLabel labelOneLevelWithFrame:CGRectZero Text:@"订单详情:"];
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

-(void)setModel:(OrderInfoModel *)model
{
    CGSize detailLabelSize = [_detailLabel sizeThatFits:CGSizeMake(1000, 1000)];
    _detailLabel.frame = CGRectMake(18, 10, SCREEN_WIDTH-36, detailLabelSize.height + 9);
    
    NSArray *products =  model.products;
    NSInteger h = _detailLabel.bottom;
    for (int i=0; i<products.count; i++) {
        NSDictionary *dic = products[i];
        NSString *name = [dic valueForKey:@"name"];
        NSInteger num = [[dic valueForKey:@"num"] integerValue];
        NSString *saleprice = [dic valueForKey:@"saleprice"];
        
        RSLabel *goodNameLbel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C2];
        goodNameLbel.textAlignment = NSTextAlignmentLeft;
        goodNameLbel.font = RS_FONT_F4;
        goodNameLbel.text = name;
        [self.contentView addSubview:goodNameLbel];
        
        RSLabel *priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C3];
        priceLabel.font = RS_FONT_F4;
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text =[NSString stringWithFormat:@"¥%@ × %ld",saleprice,num];
        [self.contentView addSubview:priceLabel];
        
        CGSize size = [goodNameLbel sizeThatFits:CGSizeMake(1000, 1000)];
        goodNameLbel.frame = CGRectMake(18, h, size.width, 12+size.height);
        CGSize priceSize = [priceLabel sizeThatFits:CGSizeMake(1000, 1000)];
        priceLabel.frame = CGRectMake(SCREEN_WIDTH-18-priceSize.width, h, priceSize.width, 12+size.height);
        h += 12+size.height;
        self.height = goodNameLbel.bottom;
    }
    model.cellHeight = self.height;
    
}

@end

@implementation LeftRightLabelCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _leftLabel = [RSLabel labelOneLevelWithFrame:CGRectMake(18, 0, SCREEN_WIDTH/2, 49) Text:@""];
        [self.contentView addSubview:_leftLabel];
        _rightLabel = [RSLabel labelTwoLevelWithFrame:CGRectMake(0, 0, 0, _leftLabel.height) Text:@""];
        [self.contentView addSubview:_rightLabel];
    }
    
    return self;
}

- (void)setModel:(OrderInfoModel *)model
{
    switch (model.displayFlag) {
        case 1:{
            _leftLabel.text = @"商品金额:";
            _rightLabel.text = model.totalprice;
            break;
        }
        case 2:{
            _leftLabel.text = @"优惠减免:";
            _rightLabel.text = [NSString stringWithFormat:@"¥%0.2f",model.couponmoney];
            _rightLabel.font = RS_FONT_F3;
            _rightLabel.textColor = RS_Theme_Color;
            break;
        }
        case 3:{
            _leftLabel.text = @"实付:";
            _rightLabel.text = [NSString stringWithFormat:@"¥%@", model.payed];
            _rightLabel.font = RS_FONT_F2;
            _rightLabel.textColor = RS_Theme_Color;

            break;
        }
        case 4:{
            _leftLabel.text = @"订单号:";
            _rightLabel.text = model.orderId;
            break;
        }
        case 5:{
            _leftLabel.text = @"下单时间:";
            _rightLabel.text = model.ordertime;
            break;
        }
        case 6:{
            _leftLabel.text = @"支付方式:";
            _rightLabel.text = model.paymethod;
            break;
        }
        default:
            break;
    }
    
    CGSize rightSize = [_rightLabel sizeThatFits:CGSizeMake(1000, 1000)];
    _rightLabel.x = SCREEN_WIDTH-18-rightSize.width;
    _rightLabel.width = rightSize.width;
    
    model.cellHeight = 49;
    
    self.lineView = [RSLineView lineViewHorizontal];
    self.lineView.x = 18;
    self.lineView.y = 48;
    [self.contentView addSubview:self.lineView];
}

@end
