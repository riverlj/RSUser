//
//  OrderCell.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-27.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSTableViewCell.h"

@interface OrderCell : RSTableViewCell
@property (nonatomic, strong) UILabel *orderIdLabel;
@property (nonatomic, strong) UILabel *oderdateLabel;
@property (nonatomic, strong) UILabel *ordertimeLabel;
@property (nonatomic, strong) UILabel *statusidLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *imgurlLabel;
@end

