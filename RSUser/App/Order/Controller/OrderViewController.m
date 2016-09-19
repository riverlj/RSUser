//
//  OrderViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderModel.h"
#import "RSSubTitleView.h"
#import "OrderInfoAndStatusViewController.h"
#import "OrderInfoModel.h"

@interface OrderViewController()
{
    NSMutableArray *_btnArray;
    RSRadioGroup *group;
    NSInteger requestType;
    
    
}
@property (nonatomic, strong)NSTimer *m_timer;

@end

@implementation OrderViewController

- (void)didClickBtn:(RSSubTitleView *)sender
{
    [group setSelectedIndex:sender.tag];
    [self setalbeItems:NO];
    
    requestType = sender.tag;
    self.pageNum = 1;
    
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = @"/order/list";
    self.useHeaderRefresh = YES;
    self.useFooterRefresh = YES;
    
    
    _btnArray = [[NSMutableArray alloc]init];
    
    NSDictionary *btn1 = @{
                           @"title":@"全部",
                           @"key":@"all",
                           @"models":[NSMutableArray array]
                           };
    NSDictionary *btn2 = @{
                           @"title":@"待评价",
                           @"key":@"needrate",
                           @"models":[NSMutableArray array]
                           };
    NSDictionary *btn3 = @{
                           @"title":@"退款",
                           @"key":@"refund",
                           @"models":[NSMutableArray array]
                           };
    [_btnArray addObject:btn1];
    [_btnArray addObject:btn2];
    [_btnArray addObject:btn3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.borderColor = RS_Line_Color.CGColor;
    view.layer.borderWidth = 1.0;
    group = [[RSRadioGroup alloc] init];
    
    for (int i=0; i<_btnArray.count; i++) {
        NSDictionary *dic = _btnArray[i];
        RSSubTitleView *title = [[RSSubTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.width/[_btnArray count], view.height)];;
        title.titleLabel.font = RS_FONT_F2;
        
        title.left = i*title.width;
        title.tag = i;
        [title setTitle:[dic valueForKey:@"title"] forState:UIControlStateNormal];
        [title addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:title];
        [group addObj:title];
    }
    
    [group setSelectedIndex:0];
    requestType = 0;
    
    self.tableView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-89);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sections = [NSMutableArray array];
    
    self.pageNum = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedGoodListView) name:@"GoodListChangedInOrderView" object:nil];
    [self.tableView.mj_header beginRefreshing];
    
    [self createTimer];
}

- (void)createTimer {
    
    self.m_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    
    for (int count = 0; count < self.models.count; count++) {
        NSArray *array = self.models[count];
        OrderModel *model = array[0];
        if (model.reduceTime > 0) {
            [model countDown];
            
            if (model.reduceTime == 0 ) {
                [self.tableView.mj_header beginRefreshing];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_TIME_CELL" object:nil];

        }else {
            
        }
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)changedGoodListView {
    [group setSelectedIndex:0];
    requestType = 0;
    self.pageNum = 1;
    [self.tableView.mj_header beginRefreshing];
}


-(void)beforeHttpRequest
{
    [super beforeHttpRequest];

    if (requestType == 0) {
        [self.params setValue:@"all" forKey:@"type"];
    }else if(requestType == 1){
        [self.params setValue:@"needrate" forKey:@"type"];
    }else if(requestType == 2){
        [self.params setValue:@"refund" forKey:@"type"];
    }
    
    if (self.pageNum == 1) {
        [self.models removeAllObjects];
    }

    [self.params setValue:@(self.models.count) forKey:@"offset"];
    
}

-(void) afterHttpSuccess:(NSArray *)data
{
    NSArray *list = data;
    NSError *error=nil;
    NSMutableArray *temp = [[MTLJSONAdapter modelsOfClass:[OrderModel class] fromJSONArray:list error:&error] mutableCopy];
    
    [temp enumerateObjectsUsingBlock:^(OrderModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        
        NSDate *orderTime = [NSDate dateFromString:obj.ordertime WithFormatter:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval order =[orderTime timeIntervalSince1970]*1;
        NSDate *nowTime = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval now=[nowTime timeIntervalSince1970]*1;

        if (obj.statusid == 0) {
            NSTimeInterval cha = now - order;
            if (cha < 30 * 60 && cha > 0) {
                obj.reduceTime = 1800 - (long)(cha);
            }else {
                obj.reduceTime = 0;
            }
        }
        
        [array addObject:obj];
        [self.models addObject:array];
    }];
    
    [self.tableView reloadData];
    

    
    __weak OrderViewController *selfB = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [selfB setalbeItems:YES];
    });
}

- (void)afterHttpFailure:(NSInteger)code errmsg:(NSString *)errmsg
{
    [self setalbeItems:YES];
    [super afterHttpFailure:code errmsg:errmsg];
}

#pragma mark tableview

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = (OrderCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.cellBtnClickedDelegate = self;
    return cell;
}

#pragma mark cellBtnClickedDelegate

- (void)goOrderInfo:(NSString *)orderId
{
    //订单详情页面
    UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://OrderInfoAndStatus?orderId=%@", orderId]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToPay:(NSString *)orderId {
    
    NSDictionary *params = @{
                             @"orderid" : orderId
                             };
    
    __weak OrderViewController *selfB = self;
    [RSHttp requestWithURL:@"/order/pay" params:params httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
        [[RSToastView shareRSToastView] hidHUD];
        NSString *url = [data objectForKey:@"url"];
        
        NSString *urlStr = [NSString URLencode:url stringEncoding:NSUTF8StringEncoding];
        NSString *orderid = orderId;
        NSString *path = [NSString stringWithFormat:@"RSUser://payWeb?urlString=%@&orderId=%@", urlStr, orderid];
        UIViewController *vc = [RSRoute getViewControllerByPath:path];
        [selfB.navigationController pushViewController:vc animated:YES];
            
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];


    
}

-(void)reCreatOrder:(NSString *)orderid {
    //再来一单
//    [[RSToastView shareRSToastView]showToast:@"敬请期待"];
    
    __weak OrderViewController *selfB = self;
    [OrderInfoModel getOrderInfo:^(OrderInfoModel *orderInfoModel) {
        if ([COMMUNTITYID integerValue] != orderInfoModel.communityid) {
            RSAlertView *alert = [[RSAlertView alloc] initWithTile:@"温馨提示" msg:[NSString stringWithFormat:@"该订单位于%@，是否切学校?", orderInfoModel.address] leftButtonTitle:@"切换学校" rightButtonTitle:@"取消" AndLeftBlock:^{
                [[LocationModel shareLocationModel] setCommuntityId:@(orderInfoModel.communityid)];
                [SchoolModel getSchoolMsg:^(SchoolModel *schoolModel) {
                    NSString *commutityName = schoolModel.name;
                    [[LocationModel shareLocationModel] setCommuntityName:commutityName];
                    [[LocationModel shareLocationModel] save];
                    [selfB oneMoreAddGoodToCart:orderid];
                }];
            } RightBlock:^{}];
            
            [alert show];
        }else {
            [self oneMoreAddGoodToCart:orderid];
        }

    } Orderid:orderid];
}

- (void) oneMoreAddGoodToCart:(NSString *)orderid {
    
    RSAlertView *alert = [[RSAlertView alloc] initWithTile:@"温馨提示" msg:@"确定清空当前购物车吗？" leftButtonTitle:@"确定" rightButtonTitle:@"取消" AndLeftBlock:^{
        [[Cart sharedCart] clearAllCartGoods];
        
        [OrderInfoModel getReOrderInfo:^(NSArray *products) {
            for (int i=0; i<products.count; i++) {
                GoodListModel *model = products[i];
                [[Cart sharedCart] addGoods:model];
            }
            
            [[Cart sharedCart] updateCartCountLabelText];
            self.cyl_tabBarController.selectedIndex = 0;
            RSCartButtion *button = (RSCartButtion *)CYLExternPlusButton;
            [button clickCart:button];
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        } Orderid:orderid];
        
    } RightBlock:^{
        
    }];
    [alert show];
}


-(void)setalbeItems:(BOOL)b
{
    [group.objArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setEnabled:b];
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GoodListChangedInOrderView" object:nil];
    [self.m_timer invalidate];
}
@end
