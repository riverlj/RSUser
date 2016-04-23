//
//  AddressTableViewCell.m
//  RSUser
//
//  Created by 李江 on 16/4/22.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "AddressTableViewCell.h"


@implementation mainTitleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.mainTitleLabel = [RSLabel lableViewWithFrame:CGRectZero bgColor:nil textColor:nil];
}

- (void)setModel:(RSModel *)model
{
    
}

@end


@implementation AddressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}



@end
