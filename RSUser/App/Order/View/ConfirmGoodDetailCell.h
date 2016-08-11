//
//  ConfirmGoodDetailCell.h
//  RSUser
//
//  Created by 李江 on 16/8/10.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTableViewCell.h"
@class ConfirmOrderDetailViewModel;

@protocol SelectedSendTimeDelegate <NSObject>

- (void)selectedSendTimeWithCategoryid:(NSInteger)categoryid withTimeLable:(UILabel *)timeLabel;

@end

@interface ConfirmGoodDetailCell : RSTableViewCell

@property (nonatomic, strong)UIImageView *categoryImageView;
@property (nonatomic, strong)UILabel *categoryLabel;
@property (nonatomic, strong)UILabel *sendTimeLabel;
@property (nonatomic ,weak)id<SelectedSendTimeDelegate> delegate;


@property (nonatomic, strong)ConfirmOrderDetailViewModel *confirmOrderDetailViewModel;


- (void)setData:(ConfirmOrderDetailViewModel *)model;

@end
