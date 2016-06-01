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
    _schoolName = [RSLabel lableViewWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 44) bgColor:[UIColor clearColor] textColor:RS_COLOR_C1];
    _schoolName.font = RS_FONT_F2;
    _schoolName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_schoolName];
}

-(void)setModel:(LocationModel *)model
{
    _schoolName.text = model.communtityName;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}

@end
