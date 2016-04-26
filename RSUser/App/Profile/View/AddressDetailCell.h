//
//  AddressCell.h
//  RedScarf
//
//  Created by lishipeng on 2016-04-25.
//  Copyright © 2016年 lishipeng. All rights reserved.
//

#import "RSTableViewCell.h"

@interface AddressDetailCell : RSTableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *checkImg;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *editBtn;
@end