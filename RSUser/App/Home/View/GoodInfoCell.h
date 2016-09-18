//
//  GoodInfoCell.h
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTableViewCell.h"
#import "ThrowLineTool.h"
#import "GoodModel.h"

@interface GoodInfoSubCell : RSTableViewCell
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *saledLabel;
@property (nonatomic, strong)UIView *lineView;

@end

@interface GoodInfoCell : GoodInfoSubCell
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UIButton *addCartBtn;

/**加按钮*/
@property (nonatomic, strong) UIImageView *addIV;
/**减按钮*/
@property (nonatomic, strong) UIImageView *subIV;
/**选中量*/
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong)GoodModel *goodmodel;

@property (nonatomic ,strong)UIImageView *newsImageView;
@property (nonatomic ,strong)UIImageView *hotImageView;

@property (nonatomic, strong)UIView *goodInfolineView;



@end
