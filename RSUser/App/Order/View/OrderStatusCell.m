//
//  OrderStatusCell.m
//  RSUser
//
//  Created by 李江 on 16/5/3.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "OrderStatusCell.h"
#import "OrderInfoModel.h"
#import "OrderLogModel.h"

@implementation OrderStatusCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setModel:(OrderInfoModel *)model
{
    NSArray *orderlogs = model.orderlog;  //订单日志
    
    CGFloat cellh = 0;
    CGPoint spoint;
    CGPoint epoint;
    for (int i=0; i<orderlogs.count; i++) {
        OrderLogModel *logmodel = orderlogs[i]; //第i条订单日志信息
        
        UIImageView *imageView = [RSImageView imageViewWithFrame:CGRectMake(0, cellh, 62, 0) ImageName:nil];
        [self setImageView:imageView Type:logmodel.changetype];
        imageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imageView];
        
        UILabel *mainLabel = [RSLabel labelOneLevelWithFrame:CGRectMake(62, cellh+20, 0, 0) Text:nil];
        mainLabel.text = logmodel.content;
        [self.contentView addSubview:mainLabel];

        
        UILabel *subTitle = [RSLabel labellWithFrame:CGRectMake(62, 0, 0, 0) Text:@"" Font:RS_FONT_F4 TextColor:RS_COLOR_C3];
        subTitle.numberOfLines = 0;
        subTitle.lineBreakMode = NSLineBreakByWordWrapping;
        NSString *str = @"";
        for (int j=0; j<logmodel.attr.count; j++) {
            if (j==0) {
                str = [NSString stringWithFormat:@"%@",logmodel.attr[j]];
            }else{
                str = [str stringByAppendingFormat:@"\n%@",logmodel.attr[j]];

            }
        }
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        subTitle.attributedText = noteStr;
        [self.contentView addSubview:subTitle];
        
        UILabel *rightLabel = [RSLabel labellWithFrame:CGRectMake(0, cellh + 21, 0, 0) Text:0 Font:RS_FONT_F4 TextColor:RS_COLOR_C3];
        rightLabel.text = logmodel.time;
        CGSize rightSize = [rightLabel sizeThatFits:CGSizeMake(1000, 1000)];
        rightLabel.width = rightSize.width;
        rightLabel.height = rightSize.height;
        rightLabel.x = SCREEN_WIDTH - 18 -rightSize.width;
        [self.contentView addSubview:rightLabel];

        CGSize mainTitlesize = [mainLabel sizeThatFits:CGSizeMake(1000, 1000)];
        mainLabel.width = mainTitlesize.width;
        mainLabel.height = mainTitlesize.height;
        
        CGSize subTitleSize = [subTitle sizeThatFits:CGSizeMake(1000, 1000)];
        subTitle.y = mainLabel.bottom + 10;
        subTitle.width = subTitleSize.width;
        subTitle.height = subTitleSize.height;
        
        UIView *lineView = [RSLineView lineViewHorizontal];
        lineView.x = 62;
        lineView.width = SCREEN_WIDTH-62;
        lineView.y = subTitle.bottom + 20;
        [self.contentView addSubview:lineView];
        
        cellh = subTitle.bottom + 21;
        
        imageView.height = subTitle.bottom - mainLabel.top + 40;
        
        
        if (i==0) {
            spoint = CGPointMake(imageView.center.x, lineView.bottom-imageView.height/2);
        }
        if (i==orderlogs.count-1) {
            epoint = CGPointMake(imageView.center.x, lineView.bottom-imageView.height/2);
        }
        
    }
    model.cellHeight = cellh;
    
    UIView *VlineView = [RSLineView lineViewVerticalWithFrame:CGRectMake(0, 0, 1, 0) Color:[NSString colorFromHexString:@"5faaff"]];
    VlineView.x = spoint.x;
    VlineView.y = spoint.y;
    VlineView.height = epoint.y - spoint.y;
    VlineView.width = 1;
    [self.contentView addSubview:VlineView];
    [self.contentView sendSubviewToBack:VlineView];
    
}


- (void)setImageView:(UIImageView *)imageView Type:(NSInteger)type
{
    switch (type) {
        case 0:{
            //未支付
            [imageView setImage:[UIImage imageNamed:@"order_dzf"]];
            break;
        }
        case 1:{
            //已支付
            [imageView setImage:[UIImage imageNamed:@"order_yzf"]];
            break;
        }
        
        case 2:{//TODO
            // 送货中
            [imageView setImage:[UIImage imageNamed:@"order_shz"]];
            break;
        }
        
        case 3:{
            //兼职已送达
            [imageView setImage:[UIImage imageNamed:@"order_dpj"]];
            break;
        }
        
        case 4:{
            //用户已收货
            [imageView setImage:[UIImage imageNamed:@"order_ywc"]];
            break;
        }
            
        case 128:{
            //订单已取消
            [imageView setImage:[UIImage imageNamed:@"order_yqx"]];
            
            break;
        }
        case 129:{
            //订单退款中
            [imageView setImage:[UIImage imageNamed:@"order_tkz"]];

            break;
        }
        case 130:{
            //已退款
            [imageView setImage:[UIImage imageNamed:@"order_ytk"]];
            break;
        }
        
        default:
            break;
    }
}


@end
