//
//  OrderStatusViewController.m
//  RSUser
//
//  Created by 李江 on 16/5/3.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "OrderStatusViewController.h"
#import "OrderInfoAndStatusViewController.h"

@interface OrderStatusViewController ()
{
    OrderInfoModel *_orderInfoModel;
}
@end

@implementation OrderStatusViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单状态";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = self.view.frame;
    
    [self formatDate];
}

- (void)formatDate {
    OrderInfoModel *model = self.orderInfoModel;
    model.cellClassName = @"OrderStatusCell";
    _orderInfoModel = model;
    
    if (!model) {
        return;
    }
    [self.models addObject:model];
    [self.tableView reloadData];
}

@end
