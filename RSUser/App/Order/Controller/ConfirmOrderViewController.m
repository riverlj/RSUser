//
//  ConfirmOrderViewController.m
//  RSUser
//
//  Created by 李江 on 16/4/21.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "AddressModel.h"
#import "CouponModel.h"
#import "AddressCell.h"
#import "GoodListModel.h"

@interface ConfirmOrderViewController ()<closeGoodsDetail>
{
    RSLabel *_priceLable;
    RSLabel *_goPayLable;
    NSMutableDictionary *_goodDic;
}
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.models = [[NSMutableArray alloc]init];
    self.tableView.backgroundColor = RS_Clear_Clor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sections = [[NSMutableArray alloc]init];
    
    [self initBottomView];
    //获取地址信息
    __weak ConfirmOrderViewController *selfB = self;
    [AddressModel getAddressList:^(NSArray *addressList) {
        [addressList enumerateObjectsUsingBlock:^(AddressModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            if (obj.checked == 1) {
                obj.cellHeight = 60;
                [array addObject:obj];
                [self.models addObject:array];
                [selfB initModelData];
            }
        }];
    }];
}

- (void)initModelData
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    SchoolModel *schoolModel = [AppConfig getAPPDelegate].schoolModel;
    schoolModel.cellHeight = 48;
    schoolModel.cellClassName = @"mainTitleCell";
    [array addObject:schoolModel];
    _goodDic = [[NSMutableDictionary alloc]init];
    [_goodDic setValue:@"0" forKey:@"isClosed"];
    [_goodDic setValue:[[Cart sharedCart] getCartDetail] forKey:@"goods"];
    [array addObject:_goodDic];
    [self.models addObject:array];
    
    //获取优惠券信息
    [CouponModel getCounponList:^(NSArray *couponList) {
        if (couponList.count == 0) {
            NSMutableArray *array3 = [[NSMutableArray alloc]init];
            CouponModel *model = [[CouponModel alloc]init];
            model.cellHeight = 49;
            model.cellClassName = @"mainTitleCell";
            model.title = @"无优惠券";
            [array3 addObject:model];
            [self.models addObject:array3];
            [self.tableView reloadData];
        }
    }];
}

- (void)initBottomView
{
    _priceLable = [RSLabel lableViewWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-64, SCREEN_WIDTH/3*2, 49) bgColor:[NSString colorFromHexString:@"6a6a6a"] textColor:RS_TabBar_count_Color];
    _priceLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_priceLable];
    
    _goPayLable = [RSLabel lableViewWithFrame:CGRectMake(SCREEN_WIDTH/3*2, _priceLable.y, SCREEN_WIDTH/3, _priceLable.height) bgColor:RS_Theme_Color textColor:RS_TabBar_count_Color];
    _goPayLable.font = Font(18);
    _goPayLable.text = @"去支付";
    [self.view addSubview:_goPayLable];
    
    RSLabel *tipview = [RSLabel lableViewWithFrame:CGRectMake(0, _priceLable.top-27, SCREEN_WIDTH, 27) bgColor:[NSString colorFromHexString:@"fdfcce"] textColor:RS_TabBar_Title_Color FontSize:12];
    tipview.text = @"您订的商品送达时会挂在宿舍门上，请注意查收哟!";
    
    [self.view addSubview:tipview];
    [self computePayNumber];
    
}


- (void)computePayNumber
{
    NSArray *cartGoods = [[Cart sharedCart]getCartDetail];
    __block CGFloat payNumber = 0.00;
    [cartGoods enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat pay = obj.num * [obj.saleprice floatValue];
        payNumber += pay;
    }];
    
    _priceLable.text = [NSString stringWithFormat:@"       总计:%.2f", payNumber];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1 && indexPath.row==1) {
        NSDictionary *dic = self.models[indexPath.section][indexPath.row];
        NSArray *array = [dic valueForKey:@"goods"];
        if ([[dic valueForKey:@"isClosed"] integerValue ]== 0) {
            return array.count * 30 + 40;
        }else{
            return 70;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        OrderDatialCell *cell = [[OrderDatialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDatialCell"];
        cell.closeGoodsDetailDelegate = self;
        NSDictionary *dic = self.models[indexPath.section][indexPath.row];
        [cell setData:dic];
        return cell;
    }
    
   return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

}

-(void)closeGoodsDetail
{
    if ([[_goodDic valueForKey:@"isClosed"] integerValue] == 0) {
        [_goodDic setValue:@"1" forKey:@"isClosed"];
    }else{
        [_goodDic setValue:@"0" forKey:@"isClosed"];
    }
    [self.tableView reloadData];
    
}
@end