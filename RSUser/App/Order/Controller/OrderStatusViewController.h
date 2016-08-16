//
//  OrderStatusViewController.h
//  RSUser
//
//  Created by 李江 on 16/5/3.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSRefreshTableViewController.h"
#import "OrderInfoModel.h"

@interface OrderStatusViewController : RSRefreshTableViewController
@property (nonatomic ,strong)NSString *orderId;
@property (nonatomic, strong)OrderInfoModel *orderInfoModel;

- (void)formatDate ;
@end
