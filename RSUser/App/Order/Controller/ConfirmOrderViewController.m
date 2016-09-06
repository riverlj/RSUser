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
#import "ConfirmGoodDetailCell.h"
#import "GoodListModel.h"
#import "ChooseCouponViewController.h"
#import "PromotionModel.h"
#import "DeliverytimeManager.h"
#import "SimulateActionSheet.h"
#import "DeliverytimeModel.h"

@interface ConfirmOrderViewController ()<SelectedSendTimeDelegate,SimulateActionSheetDelegate, UIPickerViewDataSource>
{
    RSLabel *_priceLable;
    RSLabel *_goPayLable;
    NSMutableDictionary *_goodDic;
    AddressModel *_addressModel;
    CouponModel *_couponModel;
    CouponModel * couponModel1;
    MoneypromotionViewModel *moneypromotionViewModel;
    NSArray *_couponsArray;
    NSMutableArray *array1;
    NSArray *categorys;
    MoneypromotionModel *moneyModel;
    
    SimulateActionSheet *sheet;
    NSMutableArray *keysArray;
    NSMutableArray *valuesArray;
    
    NSArray *allCategorys;
    NSInteger selectedPickerRow;
    UILabel *timeLabel;
    NSInteger selectedCategoryid;
    
    NSInteger categoryCount;
    
    NSArray *gitfsArray;
    NSArray *moneypromotionsArray;
}
@end

@implementation ConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.models = [[NSMutableArray alloc]init];
    self.tableView.backgroundColor = RS_Clear_Clor;
    self.tableView.height = SCREEN_HEIGHT - 76;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sections = [[NSMutableArray alloc]init];
    
    [self.models removeAllObjects];
    
    [self getDeliverytimes];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAddress];
}

- (void)getAddress {
    __weak ConfirmOrderViewController *selfB = self;
    [AddressModel getAddressList:^(NSArray *addressList) {
        
        [addressList enumerateObjectsUsingBlock:^(AddressModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.checked == 1) {
                _addressModel = obj;
            }
        }];
        
        [_addressModel setSelectAction:@selector(updateAddress) target:self];
        [array1 removeAllObjects];
        [array1 addObject:_addressModel];
        
        [selfB.tableView reloadData];
        
    }];
}

- (void)getDeliverytimes {
    __weak ConfirmOrderViewController *selfB = self;
    [DeliverytimeManager getDeliveryTimesFromNet:^{
        [selfB getCoupon];
    }];
}

- (void)initData {
    
    //地址
    _addressModel = [[AddressModel alloc]init];
    _addressModel.address = @"请选择地址";
    array1 = [[NSMutableArray alloc]init];
    [array1 addObject:_addressModel];
    [self.models addObject:array1];

    //根据类别分类的餐品
    NSDictionary *dic = [[Cart sharedCart] getCartsOrderByCategoryid];
    
    //购物车中的商品分类ID
    categorys = [dic allKeys];
    categoryCount = categorys.count;
    NSArray *categoryInfos = [AppConfig getAPPDelegate].schoolModel.categorys;
    
    for (int i=0; i<categorys.count; i++) {
        
        ConfirmOrderDetailViewModel *confirmOrderModel = [[ConfirmOrderDetailViewModel alloc] init];
        confirmOrderModel.categoryid = [categorys[i] integerValue];
        
        for (int j=0; j<categoryInfos.count; j++) {
            Categorys *category = categoryInfos[j];
            if (category.categoryid == confirmOrderModel.categoryid) {
                confirmOrderModel.categoryName = category.name;
            }
        }
        
        NSArray *goods = dic[@(confirmOrderModel.categoryid)];
        confirmOrderModel.goods = goods;
        confirmOrderModel.gifts = gitfsArray;
        
        NSArray *times = [[DeliverytimeManager shareDelivertimeManger] getTimesByCategoryid:confirmOrderModel.categoryid];
        
        if (times.count > 0) {
            DeliverytimeModel *deliverytimeModel = times[0];
            confirmOrderModel.sendDay = deliverytimeModel.datedesc;
            confirmOrderModel.sendTime = deliverytimeModel.time[0];
            confirmOrderModel.sendTimeDes = [NSString stringWithFormat:@"%@  %@",confirmOrderModel.sendDay, confirmOrderModel.sendTime];
        }
        
        if (i==categoryCount-1) {
            confirmOrderModel.cellLineHidden = YES;
        }
        
        confirmOrderModel.cellClassName = @"ConfirmGoodDetailCell";
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:confirmOrderModel];
        [self.models addObject:array];
    }
    
    //优惠券
    NSMutableArray *array3 = [[NSMutableArray alloc]init];
    couponModel1 = [[CouponModel alloc]init];
    couponModel1.cellHeight = 49;
    couponModel1.cellClassName = @"TwoLabelTitleCell";
    [couponModel1 setSelectAction:@selector(selectedCoupon) target:self];
    [array3 addObject:couponModel1];
    
    //商品金额
    CouponModel *couponModel2 = [[CouponModel alloc]init];
    couponModel2.cellHeight = 49;
    couponModel2.cellClassName = @"TwoLabelTitleCell";
    [array3 addObject:couponModel2];
    
    //优惠减免
    moneypromotionViewModel = [[MoneypromotionViewModel alloc]init];
    moneypromotionViewModel.cellHeight = 49;
    moneypromotionViewModel.cellClassName = @"AbatementCell";
    [array3 addObject:moneypromotionViewModel];
    
    couponModel1.title = @"优  惠  券:";
    couponModel2.title = @"商品金额:";
    moneypromotionViewModel.title = @"优惠减免:";
    
    couponModel1.subTitle = @"";
    couponModel2.subTitle = [NSString stringWithFormat:@"¥%.2f",self.totalprice];
    moneypromotionViewModel.subtitle = @"";
    
    couponModel1.hiddenLine = NO;
    couponModel2.hiddenLine = NO;
    moneypromotionViewModel.hiddenLine = YES;
    [self.models addObject:array3];
    
    
    couponModel1.subTitle = [NSString stringWithFormat:@"您有%ld张优惠券可用", _couponsArray.count];
    if (_couponsArray.count == 0) {
        couponModel1.subTitle = @"暂无可用优惠券可用";
        [couponModel1 setSelectAction:@selector(noCouponAction) target:self];
    }
    
    if (moneypromotionsArray.count != 0) {
        moneypromotionViewModel.promotions = moneypromotionsArray;
    }else {
        moneypromotionViewModel.subtitle =@"";
        moneypromotionViewModel.reduce = @"¥0";
        moneypromotionViewModel.imageName = @"";
    }
    
    [self.tableView reloadData];
    
    [self getAddress];
    [self initBottomView];
}

- (void)getCoupon {

    __weak ConfirmOrderViewController *selfB = self;
    [PromotionModel getPromotion:^(PromotionModel * promotionModel) {
        NSArray *coupons = promotionModel.coupons;
        _couponsArray = coupons;
        
        NSArray *moneypromotions = promotionModel.moneypromotions;
        moneypromotionsArray = moneypromotions;
        
        gitfsArray = promotionModel.giftpromotions;
        
        [selfB initData];
        [self computePayNumber];
    }];
}

- (void)updateAddress
{
    UIViewController *addressVc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://addresses?selectReturn=1"]];
    [self.navigationController pushViewController:addressVc animated:YES];
}

- (void)noCouponAction{
    [[RSToastView shareRSToastView] showToast:@"无可用优惠券"];
}

- (void)selectedCoupon
{
    //TODO 选择可用优惠券
    ChooseCouponViewController *couponVc = [[ChooseCouponViewController alloc]init];
    couponVc.couponArray = [_couponsArray copy];
    
    __weak ConfirmOrderViewController *selfB = self;
    couponVc.selectedCouponBlock = ^(void){
        _couponModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[RSFileStorage perferenceSavePath:@"coupon"]];
        [RSFileStorage removeFile:@"coupon"];
        
        if (_couponModel) {
            couponModel1.subTitle = [NSString stringWithFormat:@"¥%@", _couponModel.reduce];
        }else{
            couponModel1.subTitle = @"";
        }
        
        [selfB computePayNumber];
        [selfB.tableView reloadData];
    };
    
    [self.navigationController pushViewController:couponVc animated:YES];
}

#pragma mark tableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSLog(@"%ld", section);
    if (section == 0) {
        return 0;
    }
    if (section > 1 && section<=categoryCount) {
        return 0;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = categorys.count;
    if ((0 < indexPath.section &&  indexPath.section < count + 1) && indexPath.row == 0) {
        ConfirmGoodDetailCell *cell = [[ConfirmGoodDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConfirmGoodDetailCell"];
        cell.delegate = self;
        ConfirmOrderDetailViewModel *model = (ConfirmOrderDetailViewModel *)[self getModelByIndexPath:indexPath];
        [cell setData:model];
        return cell;
    }
    
   return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


- (void)initBottomView
{
    _priceLable = [RSLabel lableViewWithFrame:CGRectMake(0, SCREEN_HEIGHT-49-64, SCREEN_WIDTH/3*2, 49) bgColor:[NSString colorFromHexString:@"6a6a6a"] textColor:RS_COLOR_C7];
    _priceLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_priceLable];
    
    _goPayLable = [RSLabel lableViewWithFrame:CGRectMake(SCREEN_WIDTH/3*2, _priceLable.y, SCREEN_WIDTH/3, _priceLable.height) bgColor:RS_Theme_Color textColor:RS_COLOR_C7];
    _goPayLable.font = Font(18);
    _goPayLable.text = @"去支付";
    [_goPayLable addTapAction:@selector(createOrder) target:self];
    [self.view addSubview:_goPayLable];
    
    RSLabel *tipview = [RSLabel lableViewWithFrame:CGRectMake(0, _priceLable.top-27, SCREEN_WIDTH, 27) bgColor:[NSString colorFromHexString:@"fdfcce"] textColor:RS_COLOR_C3 FontSize:12];
    tipview.text = @"您订的商品送达时会挂在宿舍门上，请注意查收哟!";
    
    [self.view addSubview:tipview];
    
}

/**
 *  创建订单
 */
- (void)createOrder
{
    NSMutableDictionary *products = [NSMutableDictionary dictionary];
    
    for (int i=0; i<categorys.count; i++) {
        NSInteger categoryid = [categorys[i] integerValue];
        //当前品类的配送时间
        NSDictionary *dic =[[DeliverytimeManager shareDelivertimeManger]getSelectedTimeWithCategoryid:categoryid];
        
        NSArray *goods = [[Cart sharedCart] getGoodsByCategoryid:categoryid];
        
        if ([products valueForKey:dic[@"date"]]) {
            NSArray *array = [products valueForKey:dic[@"date"]];
            
            NSMutableArray *marray = [NSMutableArray arrayWithArray:array];
            [marray addObjectsFromArray:goods];
            [products setValue:marray forKey:dic[@"date"]];
            
        }else {
            
            [products setValue:goods forKey:dic[@"date"]];
            
        }
    }
    
    NSArray *giftpromotionids = [[Cart sharedCart] getGiftpromotionids];

    [[BaiduMobStat defaultStat] logEvent:@"goPay" eventLabel:@"去支付"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:_addressModel.addressId forKey:@"addressid"];
    [params setValue:COMMUNTITYID forKey:@"communityid"];
    [params setValue:@1 forKey:@"business"];
    [params setValue:products forKey:@"products"];
    [params setValue:@(0) forKey:@"couponid"];
    [params setValue:@(moneyModel.moneypromotionid) forKey:@"moneypromotionid"];
    [params setValue:giftpromotionids forKey:@"giftpromotionids"];
    
    if (_couponModel) {
        [params setValue:@(_couponModel.couponId) forKey:@"couponid"];
    }
    
    [[RSToastView shareRSToastView]showHUD:@""];
    [RSHttp requestWithURL:@"/order/create" params:params httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        [[RSToastView shareRSToastView]hidHUD];
        //清空购物车
        [[Cart sharedCart] clearDataSource];
        [[DeliverytimeManager shareDelivertimeManger] clearData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoodListChangedInOrderView" object:nil];
        
        NSString *url = [data valueForKey:@"url"];
        NSString *urlStr = [NSString URLencode:url stringEncoding:NSUTF8StringEncoding];
        NSString *orderid = [data objectForKey:@"orderid"];
        
        NSString *path = [NSString stringWithFormat:@"RSUser://payWeb?urlString=%@&orderId=%@", urlStr, orderid];
        UIViewController *vc = [RSRoute getViewControllerByPath:path];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView]hidHUD];
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
        payNumber -= [_couponModel.reduce floatValue];
    }
    
    if (moneypromotionsArray) {
        for (int i=0; i<moneypromotionsArray.count; i++) {
            MoneypromotionModel *tempmoneypromotionModel = moneypromotionsArray[i];
            payNumber -= tempmoneypromotionModel.reduce;
        }
    }
    _priceLable.text = [NSString stringWithFormat:@"       总计:%.2f", payNumber];
}

-(void)selectedSendTimeWithCategoryid:(NSInteger)categoryid withTimeLable:(UILabel *)sendtimeLabel {
    selectedCategoryid = categoryid;
    timeLabel = sendtimeLabel;
    
    NSArray *times = [[DeliverytimeManager shareDelivertimeManger] getTimesByCategoryid:categoryid];
    
    keysArray = [NSMutableArray array];
    valuesArray = [NSMutableArray array];
    [times enumerateObjectsUsingBlock:^(DeliverytimeModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [keysArray addObject:obj.datedesc];
        [valuesArray addObject:obj.time];
    }];
    
    selectedPickerRow = 0;
    sheet = [SimulateActionSheet styleDefault];
    sheet.delegate = self;
    [sheet selectRow:0 inComponent:0 animated:YES];
    [sheet selectRow:0 inComponent:1 animated:YES];
    [sheet show:self];
}

#pragma mark pickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return keysArray.count;
    } else {
        NSArray *array = valuesArray[selectedPickerRow];
        return array.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return keysArray[row];
    }else {
        NSArray *array = valuesArray[selectedPickerRow];
        return array[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        selectedPickerRow = row;
        [pickerView reloadComponent:1];
    }else {
        
    }
}

-(void)actionCancle{
    [sheet dismiss:self];
}

-(void)actionDone{
    [sheet dismiss:self];
    
    NSUInteger index = [sheet selectedRowInComponent:0];
    NSUInteger index2 = [sheet selectedRowInComponent:1];
    
    NSString * dateDes = keysArray[index];
    NSString *time = valuesArray[index][index2];
    
    timeLabel.text = [NSString stringWithFormat:@"%@  %@", dateDes,time];
    CGSize timeSize = [timeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 30)];
    timeLabel.width = timeSize.width;
    timeLabel.x = SCREEN_WIDTH - 18 - 6 - 4 - timeSize.width;
    
    NSArray *array = [[DeliverytimeManager shareDelivertimeManger]getTimesByCategoryid:selectedCategoryid];
    
    for (int i=0; i<array.count; i++) {
        DeliverytimeModel *model = array[i];
        if ([model.datedesc isEqualToString:dateDes]) {
            NSDictionary *dic = @{
                                  @"date" : model.date,
                                  @"time" : time
                                  };
            [[DeliverytimeManager shareDelivertimeManger] setSelectedTimes:dic With:selectedCategoryid];
        }
    }
    
}
@end
