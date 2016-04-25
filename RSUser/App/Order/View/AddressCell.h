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

@end

@interface OrderDatialCell: RSTableViewCell
@end

@interface OrderDatialListCell: RSTableViewCell
@property (nonatomic, strong)RSLabel *goodNameLbel;
@property (nonatomic, strong)RSLabel *priceLabel;
@end
