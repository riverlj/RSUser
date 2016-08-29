//
//  OrderInfoAndStatusViewController.m
//  RSUser
//
//  Created by 李江 on 16/5/3.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "OrderInfoAndStatusViewController.h"
#import "OrderInfoViewController.h"
#import "OrderStatusViewController.h"
#import "OrderInfoModel.h"

@interface OrderInfoAndStatusViewController ()
{
    RSRadioGroup *group;
    NSMutableArray *_btnArray;
    CGFloat btnWidth;
    UIView *contentTopView;
}
@property (nonatomic, strong)OrderInfoViewController *orderInfoVc;
@property (nonatomic, strong)OrderStatusViewController *orderStatusVc;

@property (nonatomic, strong)OrderInfoModel *orderInfoModel;

@property (nonatomic, strong)UIButton *goPayBtn;  //去支付
@property (nonatomic, strong)UIButton *cancelBtn; //取消订单
@property (nonatomic, strong)UIButton *oneMoreBtn; //再来一单
@property (nonatomic, strong)UIButton *retreatBtn; //退单
@property (nonatomic, strong)UIButton *feedBackBtn; // 反馈
@property (nonatomic, strong)UIButton *rateBtn; // 评价
@property (nonatomic, strong)UIButton *checkAppraiseBtn; // 查看评价

@property (nonatomic, strong)UIView *bottomView;


@end

@implementation OrderInfoAndStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    group = [[RSRadioGroup alloc] init];
    
    _btnArray = [[NSMutableArray alloc]init];
    
    NSDictionary *btn1 = @{
                           @"title":@"订单状态"
                           };
    NSDictionary *btn2 = @{
                           @"title":@"订单详情"
                           };
    [_btnArray addObject:btn1];
    [_btnArray addObject:btn2];
    
    [self initData];
}

- (void)initData {
    
    [self.view removeAllSubviews];
    
    contentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    contentTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentTopView];
    contentTopView.layer.borderColor = RS_Line_Color.CGColor;
    contentTopView.layer.borderWidth = 1.0;
    
    for (int i=0; i<_btnArray.count; i++) {
        NSDictionary *dic = _btnArray[i];
        RSSubTitleView *title = [[RSSubTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.width/[_btnArray count], contentTopView.height)];;
        title.titleLabel.font = RS_FONT_F2;
        
        title.left = i*title.width;
        title.tag = i;
        [title setTitle:[dic valueForKey:@"title"] forState:UIControlStateNormal];
        [title addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [contentTopView addSubview:title];
        [group addObj:title];
    }
    [group setSelectedIndex:0];
    
    __weak OrderInfoAndStatusViewController *selfB = self;
    [self getOrderInfo:^{
        [selfB.view addSubview:self.orderStatusVc.view];
        [selfB initBottom];
    }];
}


- (void)getOrderInfo:(void (^)(void))sucess {
    
    NSDictionary *params = @{
                             @"orderid" : self.orderId
                             };
    
    
    __weak OrderInfoAndStatusViewController *selfB = self;
    [[RSToastView shareRSToastView]showHUD:@""];
    [RSHttp requestWithURL:@"/order/info" params:params httpMethod:@"GET" success:^(id data) {
        NSError *error = nil;
        selfB.orderInfoModel  = [MTLJSONAdapter modelOfClass:[OrderInfoModel class] fromJSONDictionary:data error:&error];
        [[RSToastView shareRSToastView]hidHUD];
        if (error) {
            NSLog(@"%@",error);
        }
        sucess();
    }failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView]hidHUD];
        [[RSToastView shareRSToastView]showToast:errmsg];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didClickBtn:(RSSubTitleView *)sender
{
    [group setSelectedIndex:sender.tag];
    
    if (sender.tag == 0) {
        [self.orderInfoVc.view removeFromSuperview];
        [self.view addSubview:self.orderStatusVc.view];
    }
    if (sender.tag == 1) {
        [self.orderStatusVc.view removeFromSuperview];
        [self.view addSubview:self.orderInfoVc.view];
    }
}

-(OrderInfoViewController *)orderInfoVc
{
    if (!_orderInfoVc) {
        _orderInfoVc = [[OrderInfoViewController alloc]init];
        _orderInfoVc.orderId = self.orderId;
        _orderInfoVc.orderInfoModel = self.orderInfoModel;
        _orderInfoVc.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, self.view.height-108);
    }
    return _orderInfoVc;
}

-(OrderStatusViewController *)orderStatusVc
{
    if (!_orderStatusVc) {
        _orderStatusVc = [[OrderStatusViewController alloc]init];
        _orderStatusVc.orderId = self.orderId;
        _orderStatusVc.orderInfoModel = self.orderInfoModel;
        _orderStatusVc.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, self.view.height-108);
    }
    return _orderStatusVc;
}

-(void)backUp
{
    [AppConfig getAPPDelegate].tabBarControllerConfig.tabBarController.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  设置底部
 */
- (void)initBottom
{
    [self setViewsHidden];
    
    switch (_orderInfoModel.status) {
        case 0:
        {// 待支付, 取消订单、去支付
            self.cancelBtn.x = 18;
            self.cancelBtn.width = btnWidth;
            
            self.goPayBtn.x = self.cancelBtn.right + 10;
            self.goPayBtn.width = btnWidth;
            
            //TODO
            self.bottomView.hidden = NO;
        }
            break;
        case 128:
        case 130:
        {// 已取消(系统取消，用户取消), 再来一单
            self.oneMoreBtn.x = 18;
            self.oneMoreBtn.width = btnWidth;
            
            //TODO
            self.bottomView.hidden = YES;
        }
            break;
        case 1:
        {//已支付， 退单、再来一单
            self.retreatBtn.x = 18;
            self.retreatBtn.width = btnWidth;
            
            self.oneMoreBtn.x = self.retreatBtn.right + 10;
            self.oneMoreBtn.width = btnWidth;
            
            //TODO
            self.bottomView.hidden = YES;
        }
            break;
        case 129:
        {//退款中
            //底部隐藏
            self.bottomView.hidden = YES;
        }
            break;
        case 20:
        case 30:
        {//商家配餐中， 用户反馈、再来一单
            self.feedBackBtn.x = 18;
            self.feedBackBtn.width = btnWidth;
            
            self.oneMoreBtn.x = self.feedBackBtn.right + 10;
            self.oneMoreBtn.width =btnWidth;
            
            //TODO
            self.feedBackBtn.width = SCREEN_WIDTH - 36;
            self.oneMoreBtn.hidden = YES;
        }
            break;
        case 3:
        {//待评价,  用户反馈、再来一单、去评价
            self.feedBackBtn.x = 18;
            self.feedBackBtn.width = btnWidth;
            
            self.oneMoreBtn.x = self.feedBackBtn.right + 10;
            self.oneMoreBtn.width = btnWidth;
            
            self.rateBtn.x = self.oneMoreBtn.right + 10;
            self.rateBtn.width = btnWidth;
            
            //TODO
            self.feedBackBtn.width = SCREEN_WIDTH - 36;
            self.oneMoreBtn.hidden = YES;
            self.rateBtn.hidden = YES;
        }
            break;
        case 4:
        {//已完成, 用户反馈、再来一单、查看评价
            self.feedBackBtn.x = 18;
            self.feedBackBtn.width = btnWidth;
            
            self.oneMoreBtn.x = self.feedBackBtn.right + 10;
            self.oneMoreBtn.width = btnWidth;
            
            self.checkAppraiseBtn.x = self.oneMoreBtn.right + 10;
            self.checkAppraiseBtn.width = btnWidth;
            
            //TODO
            self.feedBackBtn.width = SCREEN_WIDTH - 36;
            self.oneMoreBtn.hidden = YES;
            self.checkAppraiseBtn.hidden = YES;
        }
            break;
        default:
            break;
    }

    if (self.bottomView.hidden) {
        self.orderStatusVc.view.height = self.view.height-50;
        self.orderInfoVc.view.height = self.view.height-50;
    }
}

- (UIButton *)goPayBtn {
    if (_goPayBtn) {
        return _goPayBtn;
    }
    
    _goPayBtn = (UIButton *)[RSButton buttonWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/3, 38) ImageName:@"" Text:@"去支付" TextColor:RS_COLOR_WHITE];
    _goPayBtn.layer.cornerRadius = 4;
    _goPayBtn.layer.masksToBounds = YES;
    
    [[_goPayBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        // 去支付
        [_orderInfoModel orderPaySuccess:^(NSString * url) {
            NSString *urlStr = [NSString URLencode:url stringEncoding:NSUTF8StringEncoding];
            NSString *orderid = _orderInfoModel.orderId;
            NSString *path = [NSString stringWithFormat:@"RSUser://payWeb?urlString=%@&orderId=%@", urlStr, orderid];
            UIViewController *vc = [RSRoute getViewControllerByPath:path];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }];
    
    [_goPayBtn setBackgroundColor:RS_Theme_Color];
    
    [self.bottomView addSubview:_goPayBtn];
    return _goPayBtn;
}


- (UIButton *)cancelBtn {
    if (_cancelBtn) {
        return _cancelBtn;
    }
    
    _cancelBtn = (UIButton *)[RSButton buttonWithFrame:CGRectMake(18, 10, (SCREEN_WIDTH-46)/2, 38) ImageName:@"" Text:@"取消订单" TextColor:RS_Theme_Color];
    _cancelBtn.layer.cornerRadius = 4;
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = RS_COLOR_C4.CGColor;
    [self.bottomView addSubview:_cancelBtn];
    
    @weakify(self)
    [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        RSAlertView *alert = [[RSAlertView alloc]initWithTile:@"温馨提示" msg:@"真的要取消支付吗，可是要饿肚子了哦～" leftButtonTitle:@"退单" rightButtonTitle:@"不退了" AndLeftBlock:^{
            @strongify(self)
            NSDictionary *dic = @{@"orderid":self.orderId};
            [RSHttp requestWithURL:@"/order/cancel" params:dic httpMethod:@"POSTJSON" success:^(id data) {
                [self freshenTableView];
            } failure:^(NSInteger code, NSString *errmsg) {
                [[RSToastView shareRSToastView] showToast:errmsg];
            }];
        } RightBlock:^{
            
        }];
        
        [alert show];
    }];
        return _cancelBtn;
}

- (UIButton *)oneMoreBtn {
    if (_oneMoreBtn) {
        return _oneMoreBtn;
    }
    
    _oneMoreBtn = (UIButton *)[RSButton buttonWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/3, 38) ImageName:@"" Text:@"再来一单" TextColor:RS_COLOR_WHITE];
    _oneMoreBtn.layer.cornerRadius = 4;
    _oneMoreBtn.layer.masksToBounds = YES;
    [_oneMoreBtn setBackgroundColor:RS_Theme_Color];
    
    [[_oneMoreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[RSToastView shareRSToastView] showToast:@"马上上线..."];
    }];
    [self.bottomView addSubview:_oneMoreBtn];
    return _oneMoreBtn;
}


- (UIButton *)retreatBtn {
    if (_retreatBtn) {
        return _retreatBtn;
    }
    
    _retreatBtn = (UIButton *)[RSButton buttonWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/3, 38) ImageName:@"" Text:@"退单" TextColor:RS_Theme_Color];
    _retreatBtn.layer.cornerRadius = 4;
    _retreatBtn.layer.masksToBounds = YES;
    _retreatBtn.layer.borderWidth = 1;
    _retreatBtn.layer.borderColor = RS_COLOR_C4.CGColor;
    
    [[_retreatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[RSToastView shareRSToastView] showToast:@"马上上线..."];
    }];
    
    [self.bottomView addSubview:_retreatBtn];
    return _retreatBtn;
}

-(UIButton *)feedBackBtn {
    if (_feedBackBtn) {
        return _feedBackBtn;
    }
    
    _feedBackBtn = (UIButton *)[RSButton buttonWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/3, 38) ImageName:@"" Text:@"用户反馈" TextColor:RS_COLOR_WHITE];
    _feedBackBtn.layer.cornerRadius = 4;
    _feedBackBtn.layer.masksToBounds = YES;
    _feedBackBtn.layer.borderColor = RS_COLOR_C4.CGColor;
    _feedBackBtn.layer.borderWidth = 1;
    
    [[_feedBackBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        
        NSString *path = [NSString stringWithFormat:@"RSUser://ticket?deliveryid=%@", [_orderInfoModel.deliverys[0] valueForKey:@"id"]];
        UIViewController *vc = [RSRoute getViewControllerByPath:path];
        
        if ([self.view.superview.nextResponder isKindOfClass:[OrderInfoAndStatusViewController class]]) {
            OrderInfoAndStatusViewController *orderVC = (OrderInfoAndStatusViewController*)self.view.superview.nextResponder;
            [orderVC.navigationController pushViewController:vc animated:YES];
            
        }
    }];
    
    [self.bottomView addSubview:_feedBackBtn];
    return _feedBackBtn;
}

-(UIButton *)rateBtn {
    if (_rateBtn) {
        return _rateBtn;
    }
    
    _rateBtn = (UIButton *)[RSButton buttonWithFrame:CGRectMake(0, 10, (SCREEN_WIDTH-56)/3, 38) ImageName:@"" Text:@"评价" TextColor:RS_Theme_Color];
    _rateBtn.layer.cornerRadius = 4;
    _rateBtn.layer.masksToBounds = YES;
    _rateBtn.layer.borderWidth = 1;
    _rateBtn.layer.borderColor = RS_COLOR_C4.CGColor;
    
    [[_rateBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[RSToastView shareRSToastView] showToast:@"马上上线..."];
    }];
    
    [self.bottomView addSubview:_rateBtn];
    return _rateBtn;
}

- (UIButton *)checkAppraiseBtn{
    if (_checkAppraiseBtn) {
        return _checkAppraiseBtn;
    }
    
    _checkAppraiseBtn = (UIButton *)[RSButton buttonWithFrame:CGRectMake(0, 10, (SCREEN_WIDTH-56)/3, 38) ImageName:@"" Text:@"查看评价" TextColor:RS_Theme_Color];
    _checkAppraiseBtn.layer.cornerRadius = 4;
    _checkAppraiseBtn.layer.masksToBounds = YES;
    _checkAppraiseBtn.layer.borderColor = RS_COLOR_C4.CGColor;
    _checkAppraiseBtn.layer.borderWidth = 1;
    
    [[_checkAppraiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[RSToastView shareRSToastView] showToast:@"马上上线..."];
    }];
    
    [self.bottomView addSubview:_checkAppraiseBtn];
    return _checkAppraiseBtn;
}

- (UIView *)bottomView {
    if (_bottomView) {
        return _bottomView;
    }
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-58, SCREEN_WIDTH, 58)];
    _bottomView.backgroundColor = RS_Background_Color;
    [self.view addSubview:_bottomView];
    return _bottomView;
}

- (void)setViewsHidden {
    NSInteger cancancel = _orderInfoModel.cancancel;
    NSInteger canpay = _orderInfoModel.canpay;
    NSInteger canrate = _orderInfoModel.canrate;
    NSInteger canrefund = _orderInfoModel.canrefund;
    NSInteger canfeedback = _orderInfoModel.canfeedback;
    NSInteger canreoder = _orderInfoModel.canreorder;
    
    NSInteger count = 0;
    if (cancancel == 1) {
        count ++;
        self.cancelBtn.hidden = NO;
    }else {
        self.cancelBtn.hidden = YES;
    }
    
    if (canpay == 1) {
        count ++;
        self.goPayBtn.hidden = NO;
    }else {
        self.goPayBtn.hidden = YES;
    }
    
    if (canrate == 1 || canrate == 2) {
        count ++;
        if (canrate == 1) {
            self.rateBtn.hidden = NO;
            self.checkAppraiseBtn.hidden = YES;
        }else {
            self.checkAppraiseBtn.hidden = NO;
            self.rateBtn.hidden = YES;
        }
    }else{
        self.checkAppraiseBtn.hidden = YES;
        self.rateBtn.hidden = YES;
    }
    
    if (canrefund == 1) {
        count ++;
        self.retreatBtn.hidden = NO;
    }else {
        self.retreatBtn.hidden = YES;
    }
    
    if (canfeedback == 1) {
        count ++;
        self.feedBackBtn.hidden = NO;
    }else {
        self.feedBackBtn.hidden = YES;
    }
    
    if (canreoder == 1) {
        count ++;
        self.oneMoreBtn.hidden = NO;
    }else {
        self.oneMoreBtn.hidden = YES;
    }
    
    btnWidth = (SCREEN_WIDTH - 36 - 10 * (count-1))/count;
}

- (void)freshenTableView {
    __weak OrderInfoAndStatusViewController *selfB = self;
    [self getOrderInfo:^{
        [selfB.orderInfoVc.models removeAllObjects];
        selfB.orderInfoVc.orderInfoModel = selfB.orderInfoModel;
        [selfB.orderInfoVc formatDate];
        
        [selfB.orderStatusVc.models removeAllObjects];
        selfB.orderStatusVc.orderInfoModel = selfB.orderInfoModel;
        [selfB.orderStatusVc formatDate];
        
        [self initBottom];
        
    }];
}
@end
