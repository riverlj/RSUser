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
        self.backgroundColor = RS_COLOR_C7;
        self.contentView.backgroundColor = RS_COLOR_C7;
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
            [self setImageView:imageView Type:logmodel.changetype];
        }else {
            UIImage *image = [UIImage imageFromColor:[NSString colorFromHexString:@"ffa53a"] forSize:CGSizeMake(8, 8) withCornerRadius:4];
            [imageView setImage:image];
            imageView.contentMode = UIViewContentModeCenter;
        }
        
    }
    model.cellHeight = cellh;
    self.height = cellh;

    
    UIView *VlineView = [RSLineView lineViewVerticalWithFrame:CGRectMake(0, 0, 1, 0) Color:[NSString colorFromHexString:@"ffa53a"]];
    VlineView.x = spoint.x;
    VlineView.y = spoint.y;
    VlineView.height = epoint.y - spoint.y;
    VlineView.width = 1;
    [self.contentView addSubview:VlineView];
    [self.contentView sendSubviewToBack:VlineView];
}


- (void)setImageView:(UIImageView *)imageView Type:(NSInteger)type
{
    NSDictionary *dic = @{
                          @"0" : @"order_waitpay",  //创建，待支付
                          @"1" : @"order_paycomplete", //已支付
                          @"2" : @"order_deliverying", //周特惠：进行中 其它：送货中
                          @"3" : @"order_deliveryed",  //待评价
                          @"4" : @"order_complete",   //已完成
                          @"20" : @"order_deliverying", //商家制作中
                          @"30" : @"order_deliverying", //配送中
                          @"10" : @"order_refunding", //售前退款中
                          @"11" : @"order_refund", //售前退款完成
                          @"12" : @"order_refunding", //售后退单中
                          @"13" : @"order_refund", //售后退单完成
                          @"127" : @"order_canceled", //用户自主取消
                          @"128" : @"order_canceled" //系统自动取消
                          };
    
    NSString *imageName = [dic valueForKey:[NSString stringWithFormat:@"%zd",type]];
    if (imageName.length == 0) {
        imageName = @"order_complete";
    }
    [imageView setImage:[UIImage imageNamed:imageName]];

}

@end
