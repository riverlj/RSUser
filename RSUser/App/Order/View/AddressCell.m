//
//  AddressTableViewCell.m
//  RSUser
//
//  Created by 李江 on 16/4/22.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AddressCell.h"
#import "AddressModel.h"
#import "SchoolModel.h"
#import "GoodListModel.h"
#import "CouponModel.h"


@implementation mainTitleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.mainTitleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C1];
    self.mainTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.mainTitleLabel.font = RS_FONT_F2;
    [self.contentView addSubview:self.mainTitleLabel];
}

- (void)setModel:(RSModel *)model
{
    if ([model isKindOfClass:[SchoolModel class]]) {
        SchoolModel *schoolModel = (SchoolModel *)model;
        
        NSString *text = [NSString stringWithFormat:@"送达时间: %@ (早:%@-%@)", [schoolModel.subscribedates firstObject], schoolModel.fastesttime,schoolModel.lastesttime];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
        
        NSRange range = [text rangeOfString:@"("];
        [attText addAttribute:NSForegroundColorAttributeName value:RS_COLOR_C1 range:NSMakeRange(0, range.location)];
        [attText addAttribute:NSFontAttributeName value:RS_FONT_F2 range:NSMakeRange(0, range.location)];
        
        [attText addAttribute:NSForegroundColorAttributeName value:RS_Theme_Color range:NSMakeRange(range.location, text.length-range.location)];
        
        [attText addAttribute:NSForegroundColorAttributeName value:RS_COLOR_C2 range:NSMakeRange(5, range.location-5)];
        [attText addAttribute:NSFontAttributeName value:Font(14) range:NSMakeRange(5, text.length-5)];


        
        self.mainTitleLabel.attributedText = attText;
        
        CGSize size = [self.mainTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
        self.mainTitleLabel.frame = CGRectMake(18, 0, size.width, 48);
        RSLineView *line = [RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 1) Color:RS_Line_Color];
        [self.contentView addSubview:line];
    }
    
    if ([model isKindOfClass:[CouponModel class]]) {
        CouponModel *couponModel = (CouponModel *)model;
        NSString *text = [NSString stringWithFormat:@"%@:        %@", couponModel.title, couponModel.subTitle];
        NSRange range = [text rangeOfString:@":"];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
        [attText addAttribute:NSForegroundColorAttributeName value:RS_Theme_Color range:NSMakeRange(range.location+1, text.length-range.location-1)];
        [attText addAttribute:NSFontAttributeName value:RS_FONT_F2 range:NSMakeRange(range.location+1, text.length-range.location-1)];

        
        self.mainTitleLabel.attributedText = attText;
        
        CGSize size = [self.mainTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
        self.mainTitleLabel.frame = CGRectMake(18, 0, size.width, 49);
        
        if (!couponModel.hiddenLine) {
            RSLineView *line = [RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 1) Color:RS_Line_Color];
            [self.contentView addSubview:line];
        }
    }
}

@end


@implementation AddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [super initUI];
    self.subTitleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C3];
    self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subTitleLabel.font = RS_FONT_F4;
    [self.contentView addSubview:self.subTitleLabel];
    
}

- (void)setModel:(AddressModel *)model
{
    if (model.name) {
        self.mainTitleLabel.text = [NSString stringWithFormat:@"%@  %@", model.name, model.mobile];
        self.subTitleLabel.text = model.address;
        
        [self setLayout];
    }
    else
    {
        self.subTitleLabel.text = model.address;
        self.subTitleLabel.frame = CGRectMake(18, 0, SCREEN_WIDTH-66, model.cellHeight);
        self.subTitleLabel.font = RS_FONT_F2;
    }
    
}

- (void)setLayout
{
    CGSize size = [self.mainTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
    self.mainTitleLabel.frame = CGRectMake(18, 15, SCREEN_WIDTH-66, size.height);
    CGSize subsize = [self.subTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
    
    self.subTitleLabel.frame = CGRectMake(self.mainTitleLabel.x, self.mainTitleLabel.bottom+4, self.mainTitleLabel.width, subsize.height);
}
@end


@interface OrderDatialCell()
{
    RSButton *orderDetailBtn;
}
@end
@implementation OrderDatialCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
     orderDetailBtn = [RSButton buttonWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 40) ImageName:@"order_up" Text:@"订单详情" TextColor:RS_COLOR_C1];
    orderDetailBtn.titleLabel.font = RS_FONT_F2;
    orderDetailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -orderDetailBtn.imageView.frame.size.width - orderDetailBtn.frame.size.width + orderDetailBtn.titleLabel.intrinsicContentSize.width, 0, 0);
    orderDetailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -orderDetailBtn.titleLabel.frame.size.width - orderDetailBtn.frame.size.width + orderDetailBtn.imageView.frame.size.width);
    [orderDetailBtn addTapAction:@selector(closeDetailGoods) target:self];
    orderDetailBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:orderDetailBtn];
}

- (void)setData:(NSDictionary *)dic
{
    NSArray *array = [dic valueForKey:@"goods"];
    NSInteger isClosed = [[dic valueForKey:@"isClosed"] integerValue];
    NSInteger count = array.count;
    [orderDetailBtn setImage:[UIImage imageNamed:@"order_up"] forState:UIControlStateNormal];
    if (isClosed == 1) {
        [orderDetailBtn setImage:[UIImage imageNamed:@"order_down"] forState:UIControlStateNormal];
        count = 1;
    }
    NSInteger h = 40;
    for (int i=0; i<count; i++) {
        GoodListModel *model = array[i];
        RSLabel *goodNameLbel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C2];
        goodNameLbel.textAlignment = NSTextAlignmentLeft;
        goodNameLbel.font = RS_FONT_F4;
        goodNameLbel.text = model.name;
        [self.contentView addSubview:goodNameLbel];
        
        RSLabel *priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_COLOR_C2];
        priceLabel.font = RS_FONT_F4;
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.text =[NSString stringWithFormat:@"¥%@ × %ld",model.saleprice,model.num];
        [self.contentView addSubview:priceLabel];
        
        CGSize priceSize = [priceLabel sizeThatFits:CGSizeMake(1000, 1000)];
        priceLabel.frame = CGRectMake(0, h, priceSize.width, 30);
        priceLabel.x = SCREEN_WIDTH - 18 - priceSize.width;
        goodNameLbel.frame = CGRectMake(18, h, priceLabel.x - 30, 30);
        h = 30 + h;
    }
}


- (void)closeDetailGoods
{
    if (self.closeGoodsDetailDelegate  && [self.closeGoodsDetailDelegate respondsToSelector:@selector(closeGoodsDetail)] ) {
        [self.closeGoodsDetailDelegate closeGoodsDetail];
    }
}
@end
