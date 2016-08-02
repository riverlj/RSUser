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

@interface OrderViewController()
{
    NSMutableArray *_btnArray;
    RSRadioGroup *group;
    NSInteger requestType;
    NSInteger lastRequest;
}
@end

@implementation OrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didClickBtn:(RSSubTitleView *)sender
{
    [group setSelectedIndex:sender.tag];
    [self setalbeItems:NO];
    
    requestType = sender.tag;
    self.pageNum = 1;
    
    [self.tableView.mj_header beginRefreshing];
    
}


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
                           @"title":@"待支付",
                           @"key":@"waitPay",
                           @"models":[NSMutableArray array]
                           };
    NSDictionary *btn3 = @{
                           @"title":@"已完成",
                           @"key":@"finished",
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
    
    lastRequest = requestType;
    self.pageNum = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedGoodListView) name:@"GoodListChangedInOrderView" object:nil];
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)changedGoodListView {
    [group setSelectedIndex:0];
    lastRequest = requestType;
    self.pageNum = 1;
    [self.tableView.mj_header beginRefreshing];
}


-(void)beforeHttpRequest
{
    [super beforeHttpRequest];
    
    if (requestType == 0) {
        [self.params setValue:@"all" forKey:@"type"];
    }else if(requestType == 1){
        [self.params setValue:@"new" forKey:@"type"];
    }else if(requestType == 2){
        [self.params setValue:@"completed" forKey:@"type"];
    }
    [self.params setValue:@(self.pageNum-1) forKey:@"offset"];
    
}

-(void) afterHttpSuccess:(NSArray *)data
{
    NSArray *list = data;
    NSMutableArray *temp = [[MTLJSONAdapter modelsOfClass:[OrderModel class] fromJSONArray:list error:nil] mutableCopy];
    
    if (lastRequest!=requestType) {
        lastRequest = requestType;
        self.models = temp;
    }else{
        [self.models addObjectsFromArray:temp];
    }
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

-(void)setalbeItems:(BOOL)b
{
    [group.objArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setEnabled:b];
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GoodListChangedInOrderView" object:nil];
}
@end
