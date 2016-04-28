//
//  OrderCell.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSTableViewCell.h"
#import "OrderModel.h"

@interface OrderCell : RSTableViewCell
@property (nonatomic, strong) UILabel *orderdateLabel;
@property (nonatomic, strong) UILabel *statusidLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *imgurlLabel;

@property (nonatomic ,strong)UIImageView *orderImageView;
@property (nonatomic ,strong)RSButton *statusButton;

@property (nonatomic ,strong)OrderModel *orderModel;

@end

