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
#import "ChooseCouponViewController.h"

@interface ConfirmOrderViewController ()<closeGoodsDetail>
{
    RSLabel *_priceLable;
    RSLabel *_goPayLable;
    NSMutableDictionary *_goodDic;
    AddressModel *_addressModel;
    CouponModel *_couponModel;
    NSArray *_couponsArray;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.models removeAllObjects];
    __weak ConfirmOrderViewController *selfB = self;
    [AddressModel getAddressList:^(NSArray *addressList) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [addressList enumerateObjectsUsingBlock:^(AddressModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.checked == 1) {
                _addressModel = obj;
            }
        }];
        if (!_addressModel) {
            _addressModel = [[AddressModel alloc]init];
            _addressModel.address = @"请选择地址";
        }
        _addressModel.cellHeight = 60;
        [_addressModel setSelectAction:@selector(updateAddress) target:self];
        [array addObject:_addressModel];
        [selfB.models addObject:array];
        [selfB initModelData];
    }];
  
}

- (void)updateAddress
{
    UIViewController *addressVc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://addresses?selectReturn=YES"]];
    [self.navigationController pushViewController:addressVc animated:YES];
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

    _couponModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[RSFileStorage perferenceSavePath:@"coupon"]];
    [RSFileStorage removeFile:@"coupon"];
    
    NSMutableArray *array3 = [[NSMutableArray alloc]init];
    __block CouponModel *model = [[CouponModel alloc]init];
    model.cellHeight = 49;
    model.cellClassName = @"mainTitleCell";
    [model setSelectAction:@selector(selectedCoupon) target:self];
    
    if (!_couponModel) {
        
        if (_couponModel.minfee > self.totalprice) {
            [[RSToastView shareRSToastView] showToast:[NSString stringWithFormat:@"该优惠券最小使用金额是:%ld元",_couponModel.minfee]];
            _couponModel = nil;
        }
        
        //获取优惠券信息
        [CouponModel getCounponList:^(NSArray *couponList) {
            
            _couponsArray = [[NSArray alloc]initWithArray:couponList];
            
            if (couponList.count == 0)
            {
                model.title = @"    无优惠券";
            }else
            {
                model.title = [NSString stringWithFormat:@"    您有%ld张优惠券可用", couponList.count];
            }
            [array3 addObject:model];
            [self computePayNumber];
            [self.models addObject:array3];
            [self.tableView reloadData];
        }];
    }else{
        model.title = [NSString stringWithFormat:@"    -%0.2f", _couponModel.money ];
        [array3 addObject:model];
        [self computePayNumber];
        [self.models addObject:array3];
        [self.tableView reloadData];
        
    }
    
}

- (void)selectedCoupon
{
    //TODO 选择可用优惠券
    ChooseCouponViewController *couponVc = [[ChooseCouponViewController alloc]init];
    couponVc.couponArray = [_couponsArray copy];
    [self.navigationController pushViewController:couponVc animated:YES];
}

- (void)initBottomView
{
    _priceLable = [RSLabel lableViewWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-64, SCREEN_WIDTH/3*2, 49) bgColor:[NSString colorFromHexString:@"6a6a6a"] textColor:RS_TabBar_count_Color];
    _priceLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_priceLable];
    
    _goPayLable = [RSLabel lableViewWithFrame:CGRectMake(SCREEN_WIDTH/3*2, _priceLable.y, SCREEN_WIDTH/3, _priceLable.height) bgColor:RS_Theme_Color textColor:RS_TabBar_count_Color];
    _goPayLable.font = Font(18);
    _goPayLable.text = @"去支付";
    [_goPayLable addTapAction:@selector(createOrder) target:self];
    [self.view addSubview:_goPayLable];
    
    RSLabel *tipview = [RSLabel lableViewWithFrame:CGRectMake(0, _priceLable.top-27, SCREEN_WIDTH, 27) bgColor:[NSString colorFromHexString:@"fdfcce"] textColor:RS_TabBar_Title_Color FontSize:12];
    tipview.text = @"您订的商品送达时会挂在宿舍门上，请注意查收哟!";
    
    [self.view addSubview:tipview];
    
}

/**
 *  创建订单
 */
- (void)createOrder
{
    [[BaiduMobStat defaultStat] logEvent:@"goPay" eventLabel:@"去支付"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_addressModel.addressId forKey:@"addressid"];
    [params setValue:COMMUNTITYID forKey:@"communityid"];
    [params setValue:@1 forKey:@"business"];
    [params setValue:[[Cart sharedCart] filterLocalCartData]  forKey:@"products"];
    [params setValue:[AppConfig getAPPDelegate].schoolModel.subscribedates[0] forKey:@"subscribetime"];
    [params setValue:@(0) forKey:@"couponid"];

    if (_couponModel) {
        [params setValue:@(_couponModel.couponId) forKey:@"couponid"];
    }
    [RSHttp requestWithURL:@"/order/create" params:params httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        
        //清空购物车
        [[Cart sharedCart] clearDataSource];
        
        NSString *url = [data valueForKey:@"url"];
        NSString *urlStr = [NSString URLencode:url stringEncoding:NSUTF8StringEncoding];
        NSString *orderid = [data objectForKey:@"orderid"];
        
        NSString *path = [NSString stringWithFormat:@"RSUser://payWeb?urlString=%@&orderId=%@", urlStr, orderid];
        UIViewController *vc = [RSRoute getViewControllerByPath:path];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

- (void)computePayNumber
{
    NSArray *cartGoods = [[Cart sharedCart]getCartDetail];
    __block CGFloat payNumber = 0.00;
    [cartGoods enumerateObjectsUsingBlock:^(GoodListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat pay = obj.num * [obj.saleprice floatValue];
        payNumber += pay;
    }];
    
    if (_couponModel) {
        payNumber -= _couponModel.money;
    }
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
    if (indexPath.section == 0 && indexPath.row==0) {
        return 60;
    }
    
    if (indexPath.section==1 && indexPath.row==1) {
        NSDictionary *dic = self.models[indexPath.section][indexPath.row];
        NSArray *array = [dic valueForKey:@"goods"];
        if ([[dic valueForKey:@"isClosed"] integerValue ]== 0) {
            return array.count * 30 + 40;
        }else{
            return 70;
        }
    }
    if (indexPath.section == 2 && indexPath.row==0) {
        return 49;
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
