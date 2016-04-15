//
//  SchoolAddressCell.m
//  RSUser
//
//  Created by 李江 on 16/4/15.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "SchoolAddressCell.h"
#import "LocationModel.h"

@implementation SchoolAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    _schoolName = [RSLabel lableViewWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 44) bgColor:[UIColor clearColor] textColor:RS_MainLable_Text_Color];
    _schoolName.font = RS_MainLable_Font;
    _schoolName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_schoolName];
}

-(void)setModel:(LocationModel *)model
{
    _schoolName.text = model.communtityName;
}

@end
