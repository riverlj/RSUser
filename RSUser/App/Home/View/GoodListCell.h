//
//  RSHomeCell.h
//  RSUser
//
//  Created by WuRibatu on 15/10/26.
//  Copyright © 2015年 WuRibatu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodListModel.h"
#import "CartModel.h"

@interface CartCell : RSTableViewCell
/**标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/**价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/**加按钮*/
@property (nonatomic, strong) UIImageView *addIV;
/**减按钮*/
@property (nonatomic, strong) UIImageView *subIV;
/**选中量*/
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong)UIView *lineView;

@property (nonatomic, strong)GoodListModel *cartmodel;

@end

@interface GoodListCell : CartCell
/**餐品图片*/
@property (nonatomic, strong) UIImageView *iconIV;
/**子标题*/
@property (nonatomic, strong) UILabel *menuLabel;
/**花费价格*/
@property (nonatomic, strong) UILabel *costPriceLabel;
/**已售*/
@property (nonatomic, strong) UILabel *saledLabel;

/**删除线*/
@property (nonatomic, strong)UIView *deleteLineView;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIView *addView;

@property (nonatomic, strong) NSIndexPath *indexPath;

/*已售罄*/
@property (nonatomic ,strong)UILabel *selloutLabel;
@property (nonatomic, strong) GoodListModel *listModel;

- (void)addCountClick;


@end

