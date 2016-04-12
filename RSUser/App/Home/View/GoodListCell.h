//
//  RSHomeCell.h
//  RSUser
//
//  Created by WuRibatu on 15/10/26.
//  Copyright © 2015年 WuRibatu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UIImageView *addIV;
@property (nonatomic, strong) UIImageView *subIV;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *menuLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *costPriceLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *saledLabel;

@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIView *addView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
