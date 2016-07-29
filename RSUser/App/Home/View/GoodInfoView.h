//
//  GoodInfoView.h
//  RSUser
//
//  Created by 李江 on 16/7/28.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodInfoView : UIView

@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *saledLabel;
@property (nonatomic, strong)UILabel *priceLabel;
@property (nonatomic, strong)UILabel *seckillLabel;
@property (nonatomic, strong)UIButton *addCartBtn;
@property (nonatomic, strong)UILabel *goodInfoLabel;
@property (nonatomic, strong)UILabel *goodDesLabel;

@property (nonatomic, strong)UILabel *goodInfoTitleLabel;
@property (nonatomic, strong)UILabel *goodDesTitleLabel;

@end
