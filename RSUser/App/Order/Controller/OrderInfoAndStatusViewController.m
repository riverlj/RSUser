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

@interface OrderInfoAndStatusViewController ()
{
    RSRadioGroup *group;
    NSMutableArray *_btnArray;
}
@property (nonatomic, strong)OrderInfoViewController *orderInfoVc;
@property (nonatomic, strong)OrderStatusViewController *orderStatusVc;

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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.borderColor = RS_Line_Color.CGColor;
    view.layer.borderWidth = 1.0;
    
    
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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.orderStatusVc.view];
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
        _orderInfoVc.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    }
    return _orderInfoVc;
}

-(OrderStatusViewController *)orderStatusVc
{
    if (!_orderStatusVc) {
        _orderStatusVc = [[OrderStatusViewController alloc]init];
        _orderStatusVc.orderId = self.orderId;
        _orderStatusVc.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    }
    return _orderStatusVc;
}
@end
