//
//  OrderInfoCell.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-28.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSTableViewCell.h"
#import "AddressCell.h"

@interface OrderInfoCell : RSTableViewCell

@end

@interface TitleCell : RSTableViewCell
@property (nonatomic ,strong)UILabel *title;
@property (nonatomic ,strong)UIView *lineView;

@end

@interface OrderInfoDetailCell : RSTableViewCell
@property (nonatomic ,strong)UILabel *detailLabel;
@end

@interface LeftRightLabelCell : RSTableViewCell
@property (nonatomic ,strong)UIView *lineView;
@property (nonatomic ,strong)UILabel *leftLabel;
@property (nonatomic ,strong)UILabel *rightLabel;


@end