//
//  OrderViewController.m
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderModel.h"
#import "RSRadioGroup.h"
#import "RSSubTitleView.h"

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
    self.tableView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-163);
    [super viewWillAppear:animated];
    
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
    lastRequest = requestType;
    self.pageNum = 1;
    
    [self beginHttpRequest];
    
}

- (void)didClickBtn:(RSSubTitleView *)sender
{
    [group setSelectedIndex:sender.tag];
    requestType = sender.tag;
    self.pageNum = 1;
    [self beginHttpRequest];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.url = @"/weixin/orders";
    self.useHeaderRefresh = YES;
    self.useFooterRefresh = YES;
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
}

#pragma mark tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell *cell = (OrderCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.cellBtnClickedDelegate = self;
    return cell;
}

#pragma mark cellBtnClickedDelegate
-(void)goPay
{
    //去支付页面
}

- (void)goOrderInfo:(NSString *)orderId
{
    //订单详情页面
    UIViewController *vc = [RSRoute getViewControllerByPath:[NSString stringWithFormat:@"RSUser://orderInfo?orderId=%@", orderId]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
