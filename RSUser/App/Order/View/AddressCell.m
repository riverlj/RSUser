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
#import "CartListViewController.h"
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
    self.mainTitleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_MainLable_Text_Color];
    self.mainTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.mainTitleLabel];
}

- (void)setModel:(RSModel *)model
{
    if ([model isKindOfClass:[SchoolModel class]]) {
        SchoolModel *schoolModel = (SchoolModel *)model;
        
        NSString *text = [NSString stringWithFormat:@"送达时间: %@ (早:%@-%@)", [schoolModel.subscribedates firstObject], schoolModel.fastesttime,schoolModel.lastesttime];
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
        
        NSRange range = [text rangeOfString:@"("];
        [attText addAttribute:NSForegroundColorAttributeName value:RS_MainLable_Text_Color range:NSMakeRange(0, range.location)];
        [attText addAttribute:NSForegroundColorAttributeName value:RS_Theme_Color range:NSMakeRange(range.location, text.length-range.location)];
        
        self.mainTitleLabel.attributedText = attText;
        
        CGSize size = [self.mainTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
        self.mainTitleLabel.frame = CGRectMake(18, 0, size.width, 48);
        RSLineView *line = [RSLineView lineViewHorizontalWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 1) Color:RS_Line_Color];
        [self.contentView addSubview:line];
    }
    
    if ([model isKindOfClass:[CouponModel class]]) {
        CouponModel *couponModel = (CouponModel *)model;
        NSString *text = [NSString stringWithFormat:@"优惠券:%@", couponModel.title];
        
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:text];
        [attText addAttribute:NSForegroundColorAttributeName value:RS_Theme_Color range:NSMakeRange(4, text.length-4)];
        
        self.mainTitleLabel.attributedText = attText;
        
        CGSize size = [self.mainTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
        self.mainTitleLabel.frame = CGRectMake(18, 0, size.width, 49);
        
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
    self.subTitleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_TabBar_Title_Color];
    self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subTitleLabel.font = RS_SubLable_Font;
    [self.contentView addSubview:self.subTitleLabel];
    
}

- (void)setModel:(AddressModel *)model
{
    self.mainTitleLabel.text = [NSString stringWithFormat:@"%@  %@", model.name, model.mobile];
    self.subTitleLabel.text = model.address;
    
    [self setLayout];
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
    CartListViewController *_cartVC;
    RSButton *orderDetailBtn;
}
@end
@implementation OrderDatialCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initUI
{
     orderDetailBtn = [RSButton buttonWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 40) ImageName:@"oder_up" Text:@"订单详情" TextColor:RS_MainLable_Text_Color];
    orderDetailBtn.titleLabel.font = RS_MainLable_Font;
    orderDetailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -orderDetailBtn.imageView.frame.size.width - orderDetailBtn.frame.size.width + orderDetailBtn.titleLabel.intrinsicContentSize.width, 0, 0);
    orderDetailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -orderDetailBtn.titleLabel.frame.size.width - orderDetailBtn.frame.size.width + orderDetailBtn.imageView.frame.size.width);
    [orderDetailBtn addTapAction:@selector(closeDetailGoods) target:self];
    orderDetailBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:orderDetailBtn];
    
    
    _cartVC = [[CartListViewController alloc]init];
    _cartVC.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _cartVC.tableView.scrollEnabled = NO;
    NSArray *array = [[Cart sharedCart] getCartGoods];
    _cartVC.tableView.frame = CGRectMake(0, orderDetailBtn.bottom, SCREEN_WIDTH, array.count * 30);
    _cartVC.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.contentView addSubview:_cartVC.tableView];
    self.height = 30 + array.count * 30;
    
}

- (void)closeDetailGoods
{
    NSLog(@"xxxxxx");
}

@end

@implementation OrderDatialListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    _goodNameLbel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_SubMain_Text_Color];
    _goodNameLbel.textAlignment = NSTextAlignmentLeft;
    _goodNameLbel.font = RS_SubLable_Font;
    [self.contentView addSubview:_goodNameLbel];
    
    _priceLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:RS_Clear_Clor textColor:RS_SubMain_Text_Color];
    _priceLabel.font = RS_SubLable_Font;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
}

- (void)setModel:(GoodListModel *)model
{
    _goodNameLbel.text = model.name;
    
    NSString *str = [NSString stringWithFormat:@"¥%@ × %ld",model.saleprice,model.num];
    _priceLabel.text = str;
    
    [self setLayout];
}

- (void)setLayout
{
    CGSize size = [_goodNameLbel sizeThatFits:CGSizeMake(1000, 1000)];
    _goodNameLbel.frame = CGRectMake(18, 0, size.width, size.height);
    CGSize priceSize = [_priceLabel sizeThatFits:CGSizeMake(1000, 1000)];
    _priceLabel.frame = CGRectMake(0, 0, priceSize.width, priceSize.height);
    _priceLabel.x = SCREEN_WIDTH - 18 - priceSize.width;
    
}
@end
