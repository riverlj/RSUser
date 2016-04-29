//
//  OrderInfoAddressCell.m
//  RSUser
//
//  Created by 李江 on 16/4/29.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "OrderInfoAddressCell.h"
#import "OrderInfoModel.h"

@implementation OrderInfoAddressCell

- (void)setModel:(OrderInfoModel *)model
{
    if (model.username) {
        self.mainTitleLabel.text = [NSString stringWithFormat:@"%@  %@", model.username, model.mobile];
        self.subTitleLabel.text = model.address;
        
        [self setLayout];
    }
}

- (void)setLayout
{
    self.accessoryType = UITableViewCellAccessoryNone;
    CGSize size = [self.mainTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
    self.mainTitleLabel.frame = CGRectMake(18, 15, SCREEN_WIDTH-66, size.height);
    CGSize subsize = [self.subTitleLabel sizeThatFits:CGSizeMake(1000, 1000)];
    
    self.subTitleLabel.frame = CGRectMake(self.mainTitleLabel.x, self.mainTitleLabel.bottom+4, self.mainTitleLabel.width, subsize.height);
}
@end
