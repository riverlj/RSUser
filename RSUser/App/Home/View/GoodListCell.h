//
//  RSHomeCell.h
//  RSUser
//
//  Created by WuRibatu on 15/10/26.
//  Copyright © 2015年 WuRibatu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodListCell : UITableViewCell
/**餐品图片*/
@property (nonatomic, strong) UIImageView *iconIV;
/**加按钮*/
@property (nonatomic, strong) UIImageView *addIV;
/**减按钮*/
@property (nonatomic, strong) UIImageView *subIV;

/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**子标题*/
@property (nonatomic, strong) UILabel *menuLabel;
/**价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/**花费价格*/
@property (nonatomic, strong) UILabel *costPriceLabel;
/**选中量*/
@property (nonatomic, strong) UILabel *countLabel;
/**已售*/
@property (nonatomic, strong) UILabel *saledLabel;

/**删除线*/
@property (nonatomic, strong)UIView *deleteLineView;


@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIView *addView;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
