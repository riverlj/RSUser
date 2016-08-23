//
//  OrderCell.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "OrderCell.h"

#define NOTIFICATION_TIME_CELL @"NOTIFICATION_TIME_CELL"


@interface OrderCategoryCell : RSTableViewCell

@property (nonatomic, strong)UIImageView *goodImageView;
@property (nonatomic, strong)UILabel *categoryName;
@property (nonatomic, strong)UILabel *surplusTimeLabel;
@property (nonatomic, strong)UILabel *sendTimeLabel;
@property (nonatomic, strong)UILabel *goodsCountLabel;
@property (nonatomic, strong)UILabel *lastTimeLabel;

@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, strong)OrderCategory *orderCategory;

@property (nonatomic, strong)OrderModel *orderModel;

@end

@implementation OrderCategoryCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.goodImageView = [RSImageView imageViewWithFrame:CGRectMake(18, 15, 71, 71) ImageName:@""];
        self.goodImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.goodImageView];
        
        self.categoryName = [RSLabel labellWithFrame:CGRectMake(self.goodImageView.right + 10, self.goodImageView.top, 0, 0) Text:@"" Font:Font(16) TextColor:RS_COLOR_C1];
        [self.contentView addSubview:self.categoryName];
        
        self.sendTimeLabel = [RSLabel labellWithFrame:CGRectMake(self.categoryName.left, 0, 0, 0) Text:@"" Font:RS_FONT_F4 TextColor:RS_COLOR_C3];
        [self.contentView addSubview:self.sendTimeLabel];
        
        self.surplusTimeLabel = [RSLabel labellWithFrame:CGRectMake(self.sendTimeLabel.left, self.sendTimeLabel.bottom+8, 100, self.sendTimeLabel.width) Text:@"剩余支付时间：" Font:RS_FONT_F3 TextColor:RS_COLOR_C2];
        [self.contentView addSubview:self.surplusTimeLabel];
        
        self.goodsCountLabel = [RSLabel labellWithFrame:CGRectZero Text:@"" Font:RS_FONT_F4 TextColor:RS_COLOR_C2];
        [self.contentView addSubview:self.goodsCountLabel];
        
        self.lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(18, 100, SCREEN_WIDTH-18, 1) Color:RS_Line_Color];
        [self.contentView addSubview:self.lineView];
        
        self.lastTimeLabel = [RSLabel labellWithFrame:CGRectZero Text:nil Font:RS_FONT_F3 TextColor:RS_Theme_Color];
        self.lastTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.lastTimeLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setModel:(OrderCategory *)model {
    _orderCategory = model;

    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.categoryimg]];
    self.categoryName.text = model.categoryname;
    self.sendTimeLabel.text = [NSString stringWithFormat:@"%@%@",@"配送时间：", model.deliverydatetime ];
    self.goodsCountLabel.text = [NSString stringWithFormat:@"共%ld份", model.productnum];
    
    CGSize size = [self.categoryName sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.categoryName.width = size.width;
    self.categoryName.height = size.height;
    
    CGSize sendTimeLabelSize = [self.sendTimeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.sendTimeLabel.width = sendTimeLabelSize.width;
    self.sendTimeLabel.height = sendTimeLabelSize.height;
    self.sendTimeLabel.y = self.categoryName.bottom + 10;
    
    CGSize surplusTimeLabelSize = [self.surplusTimeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.surplusTimeLabel.width = surplusTimeLabelSize.width;
    self.surplusTimeLabel.y = self.sendTimeLabel.bottom + 8;
    self.surplusTimeLabel.height = surplusTimeLabelSize.height;
    
    CGSize goodsCountLabelSize =  [self.goodsCountLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.goodsCountLabel.width = goodsCountLabelSize.width;
    self.goodsCountLabel.height = goodsCountLabelSize.height;
    self.goodsCountLabel.x = SCREEN_WIDTH - 18 - self.goodsCountLabel.width;
    self.goodsCountLabel.centerY = 101 / 2.0 + 20;
    
    self.lastTimeLabel.frame = CGRectMake(self.surplusTimeLabel.right, self.surplusTimeLabel.y, 100, self.surplusTimeLabel.height);
    
    if (self.orderModel.reduceTime > 0) {
        self.lastTimeLabel.hidden = NO;
        self.surplusTimeLabel.hidden = NO;
        self.lastTimeLabel.text = [self.orderModel currentTimeString];
    }else {
        self.lastTimeLabel.hidden = YES;
        self.surplusTimeLabel.hidden = YES;
    }
    
    
}

@end

@interface OrderCell()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *payLabel ;
    NSInteger orderid;
    
    NSMutableArray *categoryDatasource;
}
@property (nonatomic, strong)UITableView * orderTableView;

@end

@implementation OrderCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.orderTableView.dataSource = self;
        self.orderTableView.delegate = self;
        self.orderTableView.scrollEnabled = NO;

        [self.contentView addSubview:self.orderTableView];
        
        [self registerNSNotificationCenter];
        
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender
{
    if (_orderModel.business == 2) {
        
        [[RSToastView shareRSToastView] showToast:@"请前往微信公众号查看周预定订单详情"];
        return;
    }
    
    if (self.cellBtnClickedDelegate && [_cellBtnClickedDelegate respondsToSelector:@selector(goOrderInfo:)] ) {
        [_cellBtnClickedDelegate goOrderInfo:self.orderModel.orderId];
    }
    
}

-(void) setModel:(OrderModel *)model
{
    [super setModel:model];
    
    _orderModel = model;
    categoryDatasource = [[NSMutableArray alloc]init];
    
//    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
//    _orderModel = [MTLJSONAdapter modelOfClass:OrderModel.class fromJSONDictionary:dic error:nil];
    
    NSInteger count =  _orderModel.categorys.count;
    model.cellHeight = 37 + 44 + 101 * (int)count;
    
    self.orderTableView.height = model.cellHeight;
    
    NSArray *categorys = _orderModel.categorys;
    
    for (int i=0; i<categorys.count; i++) {
        OrderCategory *categoryModel = categorys[i];
        [categoryDatasource addObject:categoryModel];
    }

    [self.orderTableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return categoryDatasource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37)];
    
    _orderdateLabel = [RSLabel labellWithFrame:CGRectMake(18, 0, 0, 38) Text:@"" Font:RS_FONT_F4 TextColor:RS_COLOR_C2];
    _statusLabel = [RSLabel labellWithFrame:CGRectZero Text:@"" Font:RS_FONT_F3 TextColor:RS_Theme_Color];
    self.statusLabel.text = _orderModel.status;
    self.orderdateLabel.text = _orderModel.ordertime;
    
    [view addSubview:self.statusLabel];
    [view addSubview:self.orderdateLabel];
    
    CGSize statusLabelSize = [self.statusLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.statusLabel.frame = CGRectMake(SCREEN_WIDTH-18-statusLabelSize.width, 0, statusLabelSize.width, statusLabelSize.height);
    self.statusLabel.centerY = view.centerY;
    
    CGSize orderdateLabelSize = [self.orderdateLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.orderdateLabel.frame = CGRectMake(18, 0, orderdateLabelSize.width, orderdateLabelSize.height);
    self.orderdateLabel.centerY = view.centerY;
    
     _lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(18, 37, SCREEN_WIDTH-18, 1) Color:RS_Line_Color];
    [view addSubview:_lineView];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    _statusButton = [RSButton buttonWithFrame:CGRectMake(SCREEN_WIDTH-108, 0, 90, 26) ImageName:@"" Text:@"" TextColor:RS_COLOR_C1];
    UIColor *color = [NSString colorFromHexString:@"ffa53a"];
    _statusButton.layer.borderColor = color.CGColor;
    _statusButton.layer.borderWidth = 1;
    _statusButton.layer.masksToBounds = YES;
    _statusButton.layer.cornerRadius = 4;
    _statusButton.tag = _orderModel.statusid;
    [_statusButton setTitleColor:color forState:UIControlStateNormal];
    [_statusButton setTitleColor:color forState:UIControlStateHighlighted];
    
    _statusButton.titleLabel.font = RS_FONT_F4;
    [_statusButton addTarget:self action:@selector(statusButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *buttonText = [self getButtonText:_orderModel.statusid];
    [self.statusButton setTitle:buttonText forState:UIControlStateNormal];
    [self.statusButton setTitle:buttonText forState:UIControlStateHighlighted];
    
    self.statusButton.centerY = view.centerY;
    [view addSubview:self.statusButton];
    
    payLabel = [RSLabel labellWithFrame:CGRectMake(18, 0, 100, 44) Text:nil Font:RS_FONT_F3 TextColor:RS_Theme_Color];
    payLabel.textAlignment = NSTextAlignmentLeft;
    NSString *str = [NSString stringWithFormat:@"实付：¥%@", _orderModel.payed];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(0, 3);
    [attStr addAttribute:NSForegroundColorAttributeName value:RS_COLOR_C2 range:range];
    
    payLabel.attributedText = attStr;
    
    [view addSubview:payLabel];
    
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"orderTableCell%ld",indexPath.row]];
    if (!cell) {
       cell = [[OrderCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"orderTableCell%ld",indexPath.row]];
    }
    NSArray *categorys = _orderModel.categorys;
    OrderCategory *orderCategory =  categorys[indexPath.row];
    cell.orderModel = _orderModel;
    [cell setModel:orderCategory];
    return cell;
}

-(NSString *)getButtonText:(NSInteger)statusid {
    NSString *text = @"查看";
    switch (statusid) {
        case 0:
            text = @"去支付";
            break;
        case 1:
        case 129:
        case 20:
        case 30:
            text = @"查看";
            break;
        case 4:
        case 128:
        case 130:
            text = @"再来一单";
            break;
        case 3:
            text = @"去评价";
            break;
        default:
            break;
    }

    return text;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //跳转到订单详情
    [self goOrderInfo];
}

- (void)statusButtonClicked:(UIButton *)sender {
    switch (_orderModel.statusid) {
        case 0:
            //去支付
            [self goToPay];
            break;
        case 1:
        case 129:
        case 20:
        case 30:
            //查看
            [self goOrderInfo];
            break;
        case 4:
        case 128:
        case 130:
            //再来一单
            [self reCreatOrder];
            break;
        case 3:
            //去评价
            [[RSToastView shareRSToastView]showToast:@"敬请期待"];
            break;
        default:
            break;
    }

}

- (void)goToPay {
    if (self.cellBtnClickedDelegate && [self.cellBtnClickedDelegate respondsToSelector:@selector(goToPay:)]) {
        [self.cellBtnClickedDelegate goToPay:_orderModel.orderId];
    }
}

- (void)goOrderInfo {
    if (self.cellBtnClickedDelegate && [self.cellBtnClickedDelegate respondsToSelector:@selector(goOrderInfo:)]) {
        [self.cellBtnClickedDelegate goOrderInfo:_orderModel.orderId];
    }
}

- (void)reCreatOrder {
    if (self.cellBtnClickedDelegate && [self.cellBtnClickedDelegate respondsToSelector:@selector(reCreatOrder:)]) {
        [self.cellBtnClickedDelegate reCreatOrder:_orderModel.orderId];
    }
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    if (_orderModel.reduceTime > 0) {
        
        [self.orderTableView reloadData];
    }else {
//        [self removeNSNotificationCenter];
    }
}
@end
