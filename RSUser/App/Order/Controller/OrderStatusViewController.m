//
//  OrderStatusViewController.m
//  RSUser
//
//  Created by 李江 on 16/5/3.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "OrderStatusViewController.h"
#import "OrderInfoModel.h"
#import "OrderInfoAndStatusViewController.h"

@interface OrderStatusViewController ()
{
    OrderInfoModel *_orderInfoModel;
    UIButton *button;
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
    self.url = @"/weixin/orderinfo";
    
    [self initBottom];
    [self beginHttpRequest];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)beforeHttpRequest{
    [super beforeHttpRequest];
    [self.params setValue:self.orderId forKey:@"orderid"];
    
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    OrderInfoModel *model = [MTLJSONAdapter modelOfClass:[OrderInfoModel class] fromJSONDictionary:data error:nil];
    model.cellClassName = @"OrderStatusCell";
    _orderInfoModel = model;
    
    [self.models removeAllObjects];
    [self.models addObject:model];
    
    [self initBottom];
}


/**
 *  设置底部
 */
- (void)initBottom
{
    if (_orderInfoModel.canpay == 1) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-52 - 50 - 64-10);
         button = [RSButton themeBackGroundButton:CGRectMake(18, SCREEN_HEIGHT-52 - 50 - 64, SCREEN_WIDTH-36, 42) Text:@"去支付"];
        button.backgroundColor = RS_Theme_Color;
        [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
            // 去支付
            NSLog(@"去支付啦。。。。");
        }];
        [self.view addSubview:button];
    }
   
    NSInteger canticket = [[_orderInfoModel.deliverys[0] valueForKey:@"canticket"] integerValue];
//    if (canticket == 1) {
    if (_orderInfoModel.canfeedback == 1) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-52 - 50 - 64-10);
        button = [RSButton themeBackGroundButton:CGRectMake(18, SCREEN_HEIGHT-52 - 50 - 64, SCREEN_WIDTH-36, 42) Text:@"用户反馈"];
            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
                
                NSString *path = [NSString stringWithFormat:@"RSUser://ticket?deliveryid=%@", [_orderInfoModel.deliverys[0] valueForKey:@"id"]];
                UIViewController *vc = [RSRoute getViewControllerByPath:path];
                
                if ([self.view.superview.nextResponder isKindOfClass:[OrderInfoAndStatusViewController class]]) {
                     OrderInfoAndStatusViewController *orderVC = (OrderInfoAndStatusViewController*)self.view.superview.nextResponder;
                    [orderVC.navigationController pushViewController:vc animated:YES];

                }
                
                
            }];
        [self.view addSubview:button];
    }
}

@end
