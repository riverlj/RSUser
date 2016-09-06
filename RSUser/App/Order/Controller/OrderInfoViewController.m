//
//  OrderInfoViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-28.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "OrderInfoModel.h"
#import "PromotionModel.h"
#import "CouponModel.h"
#import "ConfirmGoodDetailCell.h"

@interface OrderInfoViewController()
@property (nonatomic, strong)NSArray *sectionTitles;
@property (nonatomic, strong)NSArray *allCategorys;


@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    self.sectionTitles = @[@"商品信息", @"配送信息", @"支付信息"];
    
    _allCategorys = [AppConfig getAPPDelegate].schoolModel.categorys;
    
    self.sections = [NSMutableArray new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.frame = self.view.frame;
    self.sections = [NSMutableArray array];
    
    [self formatDate];
}

-(void)formatDate
{
    OrderInfoModel *model = self.orderInfoModel;
    
    NSMutableArray *goodArray = [NSMutableArray arrayWithCapacity:6];
    NSArray *deliverys = model.deliverys;
    for (int i=0; i<deliverys.count; i++) {
        NSDictionary *dic = deliverys[i];
        ConfirmOrderDetailViewModel *confirmOrderViewModel = [[ConfirmOrderDetailViewModel alloc]init];
        NSString *categoryid = [dic valueForKey:@"topcategoryid"];
        confirmOrderViewModel.categoryid = [categoryid integerValue];
        NSString *time = [dic valueForKey:@"time"];
        NSString *date = [dic valueForKey:@"date"];
        confirmOrderViewModel.sendTime = time;
        confirmOrderViewModel.sendDay = date;
        confirmOrderViewModel.inOderDetail = YES;
        confirmOrderViewModel.sendTimeDes = [NSString stringWithFormat:@"%@  %@", date, time];
        confirmOrderViewModel.categoryName = [[AppConfig getAPPDelegate].schoolModel getCategoryName:[categoryid integerValue]];
        confirmOrderViewModel.cellClassName = @"ConfirmGoodDetailCell";
        
        NSArray *goods = [dic valueForKey:@"products"];
        
        NSMutableArray *viewGoods = [NSMutableArray array];
        
        for (int i=0; i<goods.count; i++) {
            NSDictionary *goodDic = goods[i];
            GoodListModel *goodlistModel = [[GoodListModel alloc]init];
            goodlistModel.num = [[goodDic valueForKey:@"num"] integerValue];
            goodlistModel.name = [goodDic valueForKey:@"name"];
            goodlistModel.saleprice = [goodDic valueForKey:@"saleprice"];
            goodlistModel.gift = [[goodDic valueForKey:@"gift"] integerValue];
            [viewGoods addObject:goodlistModel];
        }
        
        confirmOrderViewModel.viewType = @"orderinfoview";
        confirmOrderViewModel.goods = viewGoods;
        [goodArray addObject:confirmOrderViewModel];
    }
    
    //商品金额
    CouponModel *goodMoney = [[CouponModel alloc]init];
    goodMoney.cellClassName = @"TwoLabelTitleCell";
    goodMoney.title = @"商品金额：";
    goodMoney.subtextColor = RS_COLOR_C2;
    goodMoney.subTitle = [NSString stringWithFormat:@"¥%@",model.totalprice];
    [goodArray addObject:goodMoney];

    //优惠减免
    CouponModel *creditModel = [[CouponModel alloc]init];
    creditModel.cellClassName = @"TwoLabelTitleCell";
    creditModel.title = @"优惠减免：";
    creditModel.subtextColor = RS_COLOR_C2;
    creditModel.subTitle = [NSString stringWithFormat:@"¥%.2f",[model.totalprice floatValue] - [model.payed floatValue]];
    [goodArray addObject:creditModel];
    
    //实付金额
    CouponModel *payedModel = [[CouponModel alloc]init];
    payedModel.cellClassName = @"TwoLabelTitleCell";
    payedModel.title = @"实付金额：";
    payedModel.subtextFont = RS_BOLDFONT_F3;
    payedModel.subTitle = [NSString stringWithFormat:@"¥%@",model.payed];
    [goodArray addObject:payedModel];
    
    [self.models addObject:goodArray];
    
    //配送信息
    NSMutableArray *deliveryArray = [NSMutableArray arrayWithCapacity:3];
        //收货姓名
    CouponModel *userNameModel = [[CouponModel alloc]init];
    userNameModel.cellClassName = @"TwoLabelTitleCell";
    userNameModel.title = @"收货姓名：";
    userNameModel.subtextColor = RS_COLOR_C2;
    userNameModel.subTitle = [NSString stringWithFormat:@"%@",model.username];
    [deliveryArray addObject:userNameModel];
        //收货电话
    CouponModel *phoneModel = [[CouponModel alloc]init];
    phoneModel.cellClassName = @"TwoLabelTitleCell";
    phoneModel.title = @"收货电话：";
    phoneModel.subtextColor = RS_COLOR_C2;
    phoneModel.subTitle = [NSString stringWithFormat:@"%@",model.mobile];
    [deliveryArray addObject:phoneModel];
        //收货地址
    CouponModel *addressModel = [[CouponModel alloc]init];
    addressModel.cellClassName = @"TwoLabelTitleCell";
    addressModel.title = @"收货地址：";
    addressModel.subtextColor = RS_COLOR_C2;
    addressModel.subTitle = [NSString stringWithFormat:@"%@",model.address];
    [deliveryArray addObject:addressModel];
    
    [self.models addObject:deliveryArray];
    
    //支付信息
    NSMutableArray *payArray = [NSMutableArray arrayWithCapacity:3];
        //订单号
    CouponModel *orderNumModel = [[CouponModel alloc]init];
    orderNumModel.cellClassName = @"TwoLabelTitleCell";
    orderNumModel.title = @"订  单  号：";
    orderNumModel.subtextColor = RS_COLOR_C2;
    orderNumModel.subTitle = [NSString stringWithFormat:@"%@",model.orderId];
    [payArray addObject:orderNumModel];
        //下单时间
    CouponModel *orderTimeModel = [[CouponModel alloc]init];
    orderTimeModel.cellClassName = @"TwoLabelTitleCell";
    orderTimeModel.title = @"下单时间：";
    orderTimeModel.subtextColor = RS_COLOR_C2;
    orderTimeModel.subTitle = [NSString stringWithFormat:@"%@",model.ordertime];
    [payArray addObject:orderTimeModel];
        //支付方式
    
    if (![model.paymethod isEqualToString:@""]) {
        CouponModel *orderPayWayModel = [[CouponModel alloc]init];
        orderPayWayModel.cellClassName = @"TwoLabelTitleCell";
        orderPayWayModel.title = @"支付方式：";
        orderPayWayModel.subtextColor = RS_COLOR_C2;
        orderPayWayModel.subTitle = [NSString stringWithFormat:@"%@",model.paymethod];
        [payArray addObject:orderPayWayModel];
    }
    [self.models addObject:payArray];
    
    [self.tableView reloadData];
}

#pragma mark tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = RS_Background_Color;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH, 20)];
    label.backgroundColor = RS_Background_Color;
    label.text = self.sectionTitles[section];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = RS_FONT_F4;
    label.textColor = RS_COLOR_C3;
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSModel *model = [self getModelByIndexPath:indexPath];
    if (0 == indexPath.section &&[model isKindOfClass:[ConfirmOrderDetailViewModel class]]) {
            ConfirmGoodDetailCell *cell = [[ConfirmGoodDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConfirmGoodDetailCell"];
            ConfirmOrderDetailViewModel *model = (ConfirmOrderDetailViewModel *)[self getModelByIndexPath:indexPath];
            [cell setData:model];
            return cell;
        }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
@end
