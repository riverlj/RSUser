//
//  CouponCell.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-26.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSTableViewCell.h"

@interface CouponCell : RSTableViewCell
@property (nonatomic, strong) UILabel *couponidLabel;
@property (nonatomic, strong) UILabel *orderidLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *begintimeLabel;
@property (nonatomic, strong) UILabel *endtimeLabel;
@property (nonatomic, strong) UILabel *minfeeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *discountmaxLabel;
@end

