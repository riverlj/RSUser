//
//  AddressTableViewCell.h
//  RSUser
//
//  Created by 李江 on 16/4/22.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSTableViewCell.h"

@interface mainTitleCell : RSTableViewCell
@property (nonatomic ,strong)RSLabel *mainTitleLabel;
@end

@interface AddressCell : mainTitleCell
@property (nonatomic ,strong)RSLabel *subTitleLabel;
@property (nonatomic, strong)UIImageView *addreessImageView;
@end

@protocol closeGoodsDetail <NSObject>
- (void)closeGoodsDetail;
@end

@interface OrderDatialCell: RSTableViewCell
@property (nonatomic ,weak) id<closeGoodsDetail> closeGoodsDetailDelegate;
- (void)setData:(NSDictionary *)dic;
@end

@interface TwoLabelTitleCell : mainTitleCell
@property (nonatomic, strong)UILabel *subTitleLabel;
@end

@interface  AbatementCell: TwoLabelTitleCell
@property (nonatomic, strong)UIImageView *abatementTypeImageView;
@property (nonatomic, strong)UILabel *desLabel;

@end
