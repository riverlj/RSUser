//
//  OrderInfoViewController.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-28.
//  Copyright (c) 2015年 lishipeng. All rights reserved.
//

#import "RSRefreshTableViewController.h"
@class OrderInfoModel;

@interface OrderInfoViewController : RSRefreshTableViewController
@property (nonatomic ,strong)NSString *orderId;
@property (nonatomic, strong)OrderInfoModel *orderInfoModel;
-(void) formatDate;
@end

